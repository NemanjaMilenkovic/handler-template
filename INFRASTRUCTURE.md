# 🏗️ Infrastructure Guide

This guide covers the complete infrastructure setup for the Handler application, including monitoring, observability, and error tracking.

## 🚀 Quick Start

### Option 1: Hybrid Mode (Recommended for Development)

```bash
# Start infrastructure services (Docker)
npm run infra:start

# Start application services (Local Node.js)
pnpm dev

# Test everything
npm run infra:test
```

### Option 2: Full Docker Mode (Production-like)

```bash
# Start everything in Docker
npm run docker:dev

# Test everything
npm run test:full

# View logs
npm run docker:dev:logs

# Stop everything
npm run docker:dev:stop
```

## 📊 Services Overview

| Service           | Hybrid Mode    | Docker Mode | Port | Purpose               |
| ----------------- | -------------- | ----------- | ---- | --------------------- |
| **Web App**       | Local Node.js  | Docker      | 3000 | Next.js frontend      |
| **API Server**    | Local Node.js  | Docker      | 3001 | Express backend       |
| **Prometheus**    | Docker         | Docker      | 9090 | Metrics collection    |
| **Grafana**       | Docker         | Docker      | 3002 | Metrics visualization |
| **Sentry**        | External/Local | Docker      | 9000 | Error tracking        |
| **OpenTelemetry** | -              | Docker      | 8888 | Trace collection      |

## 🔧 Development Modes

### 🔀 Hybrid Mode (Default)

**Best for:** Daily development, debugging, hot reloading

**Pros:**

- ✅ Fast hot reloading
- ✅ Easy debugging
- ✅ IDE integration
- ✅ Quick startup

**Cons:**

- ❌ Requires Node.js/pnpm locally
- ❌ Less production-like

**Commands:**

```bash
npm run infra:start      # Start infrastructure
npm run infra:stop       # Stop infrastructure
npm run infra:status     # Check status
npm run infra:test       # Test infrastructure
```

### 🐳 Full Docker Mode

**Best for:** Production testing, team consistency, CI/CD

**Pros:**

- ✅ Production parity
- ✅ Team consistency
- ✅ Complete isolation
- ✅ Includes Sentry locally

**Cons:**

- ❌ Slower hot reloading
- ❌ More complex debugging
- ❌ Larger resource usage

**Commands:**

```bash
npm run docker:dev           # Start everything
npm run docker:dev:stop      # Stop everything
npm run docker:dev:logs      # View logs
npm run docker:dev:restart   # Restart everything
npm run test:full           # Test everything
```

## 🐛 Sentry Error Tracking

### Setup Options

#### Option A: External Sentry (Recommended)

1. Create account at [sentry.io](https://sentry.io)
2. Create a new project
3. Copy your DSN
4. Update `.env`:

```bash
SENTRY_DSN=https://your-dsn@sentry.io/project-id
NEXT_PUBLIC_SENTRY_DSN=https://your-dsn@sentry.io/project-id
```

#### Option B: Local Sentry (Docker Mode Only)

When using `npm run docker:dev`, Sentry runs locally at http://localhost:9000

**First-time setup:**

```bash
# Start the stack
npm run docker:dev

# Wait for Sentry to be ready (2-3 minutes)
# Access http://localhost:9000
# Create admin account
# Create a project
# Copy the DSN to your .env file
```

### Testing Sentry

#### Generate Test Errors

```bash
# Generate a server error
npm run sentry:test

# Or manually
curl http://localhost:3001/test-error
```

#### Check Error in Sentry

1. **External Sentry:** Check your [sentry.io dashboard](https://sentry.io)
2. **Local Sentry:** Visit http://localhost:9000

## 📈 Monitoring & Observability

### Prometheus (Metrics)

- **URL:** http://localhost:9090
- **Purpose:** Collects application and infrastructure metrics
- **Key Metrics:**
  - `http_request_duration_seconds` - API response times
  - `http_requests_total` - Request counts
  - `up` - Service health

### Grafana (Dashboards)

- **URL:** http://localhost:3002
- **Login:** admin/admin
- **Purpose:** Visualize Prometheus metrics
- **Dashboards:** Custom dashboards for your application

### OpenTelemetry (Traces)

- **URL:** http://localhost:8888/metrics
- **Purpose:** Distributed tracing and additional metrics
- **Only available in Docker mode**

## 🧪 Testing

### Quick Health Check

```bash
npm run infra:status
```

### Basic Infrastructure Test

```bash
npm run infra:test
```

### Full Stack Test (Docker Mode)

```bash
npm run test:full
```

### Load Testing

```bash
./load-test.sh
```

## 📁 File Structure

```
├── docker-compose.dev.yml          # Full Docker development stack
├── docker-compose.prod.yml         # Production stack
├── prometheus/
│   ├── prometheus.yml              # Local development config
│   └── prometheus.docker.yml       # Docker development config
├── otel-collector-config.yml       # OpenTelemetry configuration
├── scripts/
│   ├── infra-manager.js            # Node.js infrastructure manager
│   └── package.json                # Scripts package config
├── test-infrastructure.sh          # Basic infrastructure tests
├── test-infrastructure-full.sh     # Full stack tests
├── start-infrastructure.sh         # Hybrid mode startup
├── stop-infrastructure.sh          # Stop all infrastructure
└── env.example                     # Environment variables template
```

## 🔧 Environment Variables

Copy `env.example` to `.env` and configure:

```bash
# Sentry (External)
SENTRY_DSN=https://your-dsn@sentry.io/project-id
NEXT_PUBLIC_SENTRY_DSN=https://your-dsn@sentry.io/project-id

# Sentry (Local Docker - auto-configured)
SENTRY_SECRET_KEY=development-secret-key

# Grafana
GRAFANA_PASSWORD=admin123

# OpenTelemetry
OTEL_SERVICE_NAME=handler-app
OTEL_SERVICE_VERSION=1.0.0
```

## 🚨 Troubleshooting

### Port Conflicts

```bash
# Check what's using a port
lsof -i :3000

# Kill process on port
kill -9 $(lsof -ti:3000)
```

### Docker Issues

```bash
# View logs
npm run docker:dev:logs

# Restart single service
docker-compose -f docker-compose.dev.yml restart server

# Rebuild containers
npm run docker:dev:stop
npm run docker:dev
```

### Sentry Not Working

1. Check DSN is correct in `.env`
2. Verify Sentry service is running
3. Check server logs for Sentry errors
4. Test error endpoint: `npm run sentry:test`

## 📚 Commands Reference

### Infrastructure Management

```bash
npm run infra:start         # Start hybrid infrastructure
npm run infra:stop          # Stop infrastructure
npm run infra:status        # Check status
npm run infra:restart       # Restart infrastructure
npm run infra:test          # Test infrastructure
```

### Docker Development

```bash
npm run docker:dev          # Start full Docker stack
npm run docker:dev:stop     # Stop Docker stack
npm run docker:dev:logs     # View logs
npm run docker:dev:restart  # Restart Docker stack
```

### Testing

```bash
npm run test:full           # Test full infrastructure
npm run sentry:test         # Generate test error
./load-test.sh              # Generate load
```

### Application Development

```bash
pnpm dev                    # Start apps (hybrid mode)
pnpm build                  # Build all packages
pnpm test                   # Run tests
pnpm lint                   # Lint code
```

## 🎯 Best Practices

1. **Use Hybrid Mode** for daily development
2. **Use Docker Mode** for testing production issues
3. **Monitor logs** regularly: `npm run docker:dev:logs`
4. **Test error tracking** after setup: `npm run sentry:test`
5. **Check metrics** in Grafana dashboards
6. **Run tests** before committing: `npm run test:full`

## 🤝 Team Onboarding

New team members should:

1. Clone the repository
2. Copy `env.example` to `.env`
3. Run `npm run infra:start`
4. Run `pnpm dev` in another terminal
5. Test with `npm run infra:test`
6. Set up Sentry account and update `.env`

For production-like testing:

1. Run `npm run docker:dev`
2. Wait 2-3 minutes for all services
3. Test with `npm run test:full`
