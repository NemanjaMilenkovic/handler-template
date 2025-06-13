#!/usr/bin/env node

const { spawn, exec } = require('child_process');
const path = require('path');

// Colors for console output
const colors = {
  reset: '\x1b[0m',
  red: '\x1b[31m',
  green: '\x1b[32m',
  yellow: '\x1b[33m',
  blue: '\x1b[34m',
  cyan: '\x1b[36m',
};

function log(message, color = 'reset') {
  console.log(`${colors[color]}${message}${colors.reset}`);
}

function execPromise(command) {
  return new Promise((resolve, reject) => {
    exec(command, (error, stdout, stderr) => {
      if (error) {
        reject({ error, stdout, stderr });
      } else {
        resolve({ stdout, stderr });
      }
    });
  });
}

async function checkPort(port) {
  try {
    await execPromise(`lsof -i :${port}`);
    return true; // Port is in use
  } catch {
    return false; // Port is free
  }
}

async function checkDocker() {
  try {
    await execPromise('docker info');
    return true;
  } catch {
    return false;
  }
}

async function isContainerRunning(name) {
  try {
    const { stdout } = await execPromise(`docker ps -q --filter "name=${name}"`);
    return stdout.trim().length > 0;
  } catch {
    return false;
  }
}

async function startContainer(name, command) {
  try {
    if (await isContainerRunning(name)) {
      log(`⚠️  ${name} is already running`, 'yellow');
      return true;
    }

    await execPromise(command);
    log(`✅ ${name} started successfully`, 'green');
    return true;
  } catch (error) {
    log(`❌ Failed to start ${name}: ${error.error?.message || error}`, 'red');
    return false;
  }
}

async function stopContainer(name) {
  try {
    if (!(await isContainerRunning(name))) {
      log(`⚠️  ${name} is not running`, 'yellow');
      return true;
    }

    await execPromise(`docker stop ${name} && docker rm ${name}`);
    log(`✅ ${name} stopped successfully`, 'green');
    return true;
  } catch (error) {
    log(`❌ Failed to stop ${name}: ${error.error?.message || error}`, 'red');
    return false;
  }
}

async function waitForService(name, url, maxAttempts = 15) {
  log(`⏳ Waiting for ${name} to be ready...`, 'yellow');

  for (let i = 0; i < maxAttempts; i++) {
    try {
      await execPromise(`curl -s "${url}" > /dev/null`);
      log(`✅ ${name} is ready!`, 'green');
      return true;
    } catch {
      await new Promise(resolve => setTimeout(resolve, 2000));
    }
  }

  log(`❌ ${name} failed to start within timeout`, 'red');
  return false;
}

async function runScript(scriptName) {
  return new Promise((resolve, reject) => {
    const scriptPath = path.join(process.cwd(), scriptName);
    const child = spawn('bash', [scriptPath], {
      stdio: 'inherit',
      cwd: process.cwd(),
    });

    child.on('close', code => {
      if (code === 0) {
        resolve();
      } else {
        reject(new Error(`Script ${scriptName} failed with exit code ${code}`));
      }
    });
  });
}

const commands = {
  async start() {
    log('🚀 Starting Infrastructure...', 'cyan');

    // Check Docker
    if (!(await checkDocker())) {
      log('❌ Docker is not running. Please start Docker first.', 'red');
      process.exit(1);
    }

    // Check ports
    const ports = [
      { port: 3012, name: 'Server' },
      { port: 3011, name: 'Web App' },
      { port: 9090, name: 'Prometheus' },
      { port: 3013, name: 'Grafana' },
    ];

    log('\n🔍 Checking port availability...', 'blue');
    for (const { port, name } of ports) {
      const inUse = await checkPort(port);
      if (inUse) {
        log(`⚠️  Port ${port} (${name}) is in use`, 'yellow');
      } else {
        log(`✅ Port ${port} (${name}) is available`, 'green');
      }
    }

    // Start containers
    log('\n🐳 Starting containers...', 'blue');

    const prometheusCmd =
      'docker run -d --name prometheus -p 9090:9090 -v $(pwd)/prometheus:/etc/prometheus prom/prometheus:latest --config.file=/etc/prometheus/prometheus.yml';
    const grafanaCmd =
      'docker run -d --name grafana -p 3013:3000 -e "GF_SECURITY_ADMIN_PASSWORD=admin" grafana/grafana:latest';

    await startContainer('prometheus', prometheusCmd);
    await startContainer('grafana', grafanaCmd);

    // Wait for services
    log('\n⏳ Waiting for services...', 'blue');
    await waitForService('Prometheus', 'http://localhost:9090/api/v1/targets');
    await waitForService('Grafana', 'http://localhost:3013/login');

    log('\n✅ Infrastructure started successfully!', 'green');
    log('\nNext steps:', 'blue');
    log('  • Start dev servers: npm run dev');
    log('  • Test everything: npm run infra:test');
    log('  • Access Grafana: http://localhost:3013 (admin/admin)');
    log('  • Access Prometheus: http://localhost:9090');
  },

  async stop() {
    log('🛑 Stopping Infrastructure...', 'cyan');

    // Stop containers
    log('\n🐳 Stopping containers...', 'blue');
    await stopContainer('prometheus');
    await stopContainer('grafana');

    // Kill development processes
    log('\n🔄 Stopping development processes...', 'blue');
    try {
      await execPromise('pkill -f "turbo.*dev" 2>/dev/null || true');
      log('✅ Development processes stopped', 'green');
    } catch {
      log('⚠️  No development processes running', 'yellow');
    }

    log('\n✅ Infrastructure stopped successfully!', 'green');
  },

  async test() {
    log('🧪 Running infrastructure tests...', 'cyan');
    try {
      await runScript('./scripts/infra/test-infrastructure.sh');
    } catch (error) {
      log(`❌ Tests failed: ${error.message}`, 'red');
      process.exit(1);
    }
  },

  async restart() {
    await this.stop();
    await new Promise(resolve => setTimeout(resolve, 2000)); // Wait 2 seconds
    await this.start();
  },

  async status() {
    log('📊 Infrastructure Status', 'cyan');

    // Check containers
    try {
      const { stdout } = await execPromise(
        'docker ps --format "table {{.Names}}\\t{{.Status}}\\t{{.Ports}}" --filter "name=prometheus" --filter "name=grafana"'
      );
      log('\n🐳 Docker Containers:', 'blue');
      log(stdout);
    } catch (error) {
      log('❌ Failed to get container status', 'red');
    }

    // Check ports
    log('\n🌐 Port Status:', 'blue');
    const services = [
      { port: 3012, name: 'Server', url: 'http://localhost:3012' },
      { port: 3011, name: 'Web App', url: 'http://localhost:3011' },
      { port: 9090, name: 'Prometheus', url: 'http://localhost:9090' },
      { port: 3013, name: 'Grafana', url: 'http://localhost:3013' },
    ];

    for (const { port, name, url } of services) {
      const inUse = await checkPort(port);
      if (inUse) {
        log(`✅ ${name}: ${url}`, 'green');
      } else {
        log(`❌ ${name}: Not running`, 'red');
      }
    }
  },

  async docker() {
    log('🐳 Starting Full Docker Development Stack...', 'cyan');
    try {
      await execPromise('docker-compose -f docker-compose.dev.yml up -d --build');
      log('\n✅ Docker stack started successfully!', 'green');
      log('\nServices available:', 'blue');
      log('  • Web App: http://localhost:3011');
      log('  • API Server: http://localhost:3012');
      log('  • Prometheus: http://localhost:9090');
      log('  • Grafana: http://localhost:3013 (admin/admin)');
      log('  • Sentry: http://localhost:9000');
      log('  • OpenTelemetry: http://localhost:8888');
      log('\nNext steps:', 'blue');
      log('  • Test everything: bash scripts/infra/test-infrastructure-full.sh');
      log('  • View logs: npm run docker:dev:logs');
      log('  • Stop stack: npm run docker:dev:stop');
    } catch (error) {
      log(`❌ Failed to start Docker stack: ${error.error?.message || error}`, 'red');
      process.exit(1);
    }
  },

  help() {
    log('🔧 Infrastructure Manager', 'cyan');
    log('\nUsage: node scripts/infra-manager.js <command>', 'blue');
    log('\nCommands:');
    log('  start    - Start infrastructure components (Prometheus & Grafana only)');
    log('  stop     - Stop all infrastructure components');
    log('  restart  - Stop and start infrastructure');
    log('  test     - Run infrastructure tests');
    log('  status   - Show current infrastructure status');
    log('  docker   - Start full Docker development stack (all services)');
    log('  help     - Show this help message');
    log('\nNPM Scripts:');
    log('  npm run infra:start        - Hybrid mode (infra in Docker, apps local)');
    log('  npm run docker:dev         - Full Docker mode (everything in Docker)');
    log('  npm run docker:dev:stop    - Stop Docker stack');
    log('  npm run infra:test         - Test hybrid mode');
    log('  npm run sentry:test        - Generate test error for Sentry');
    log('\nDevelopment Modes:');
    log('  🔧 Hybrid (Recommended): npm run infra:start + pnpm dev');
    log('  🐳 Full Docker: npm run docker:dev');
  },
};

// Main execution
async function main() {
  const command = process.argv[2] || 'help';

  if (commands[command]) {
    try {
      await commands[command]();
    } catch (error) {
      log(`❌ Command failed: ${error.message}`, 'red');
      process.exit(1);
    }
  } else {
    log(`❌ Unknown command: ${command}`, 'red');
    commands.help();
    process.exit(1);
  }
}

if (require.main === module) {
  main();
}

module.exports = commands;
