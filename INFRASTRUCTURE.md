# Infrastructure Guide

A comprehensive guide to the enterprise-grade infrastructure stack included in this template.

## 📋 Table of Contents

- [Overview](#overview)
- [Quick Start](#quick-start)
- [Development Modes](#development-modes)
- [Infrastructure Services](#infrastructure-services)
- [Available Commands](#available-commands)
- [Configuration](#configuration)
- [Monitoring & Observability](#monitoring--observability)
- [Troubleshooting](#troubleshooting)
- [Team Onboarding](#team-onboarding)
- [Best Practices](#best-practices)

---

## 🎯 Overview

This template provides a complete observability and monitoring stack that mirrors production environments. You can run infrastructure in two modes:

1. **Hybrid Mode** (Recommended): Infrastructure in Docker, applications local
2. **Full Docker Mode**: Everything containerized for production parity

### Infrastructure Stack

| Component         | Purpose                      | Port | Status                  |
| ----------------- | ---------------------------- | ---- | ----------------------- |
| **Prometheus**    | Metrics collection & storage | 9090 | ✅ Production-ready     |
| **Grafana**       | Monitoring dashboards        | 3002 | ✅ Pre-configured       |
| **OpenTelemetry** | Distributed tracing          | 8888 | ✅ Auto-instrumentation |
| **Sentry**        | Error tracking               | 9000 | ✅ Local instance       |
| **Winston**       | Structured logging           | -    | ✅ Application logs     |

---

## 🚀 Quick Start

### Prerequisites

```bash
# Ensure you have required tools
node --version  # v20.0.0+
pnpm --version  # v8.15.4+
docker --version
docker-compose --version
```

### 30-Second Setup

```bash
# Clone and install
git clone <repo-url> && cd handler
pnpm install

# Start infrastructure + development
npm run infra:start && pnpm dev

# Verify everything works
npm run infra:test
```

### Access Your Services

- **Web App**: http://localhost:3011
- **API Server**: http://localhost:3012
- **Grafana**: http://localhost:3013 (admin/admin)
- **Prometheus**: http://localhost:9090

---

## 🔄 Development Modes

### Mode 1: Hybrid Development (Recommended)

**Best for**: Day-to-day development with fast hot reloading

```bash
# Start infrastructure stack
npm run infra:start

# Start your applications locally
pnpm dev

# Test everything
npm run infra:test
```

**What runs where**:

- 🐳 **Docker**: Prometheus, Grafana, OpenTelemetry
- 💻 **Local**: Web app (3011), API server (3012)

**Advantages**:

- ⚡ Lightning-fast hot reloading
- 🔧 Easy debugging with source maps
- 💾 Lower resource usage
- 🔄 Quick iteration cycles

### Mode 2: Full Docker Development

**Best for**: Testing production parity, CI/CD simulation

```bash
# Start everything in Docker
npm run docker:dev

# Test full stack including Sentry
npm run test:full

# View logs from all containers
npm run docker:dev:logs
```

**What runs where**:

- 🐳 **Docker**: Everything (Web, API, Infrastructure, Sentry)

**Advantages**:

- 🎯 Production parity
- 🧪 Complete integration testing
- 🔒 Isolated environments
- 📊 Full observability stack

---

## 🛠 Infrastructure Services

### Prometheus (Port 9090)

**Purpose**: Metrics collection and storage

**Key Features**:

- HTTP request metrics
- Application performance metrics
- Custom business metrics
- Health check endpoints

**Endpoints**:

- Dashboard: http://localhost:9090
- Targets: http://localhost:9090/targets
- Metrics: http://localhost:9090/metrics

### Grafana (Port 3002)

**Purpose**: Visualization and alerting

**Pre-configured Dashboards**:

- Application Overview
- HTTP Request Metrics
- System Health
- Custom Business Metrics

**Default Login**:

- Username: `admin`
- Password: `admin`

### OpenTelemetry Collector (Port 8888)

**Purpose**: Telemetry data collection and processing

**Capabilities**:

- Distributed tracing
- Metrics aggregation
- Log collection
- Data export to multiple backends

### Sentry (Port 9000) - Docker Mode Only

**Purpose**: Error tracking and performance monitoring

**Features**:

- Real-time error tracking
- Performance monitoring
- Release tracking
- User feedback

**Test Error Endpoint**: `GET http://localhost:3012/test-error`

---

## 📚 Available Commands

### Infrastructure Management

```bash
# Core infrastructure commands
npm run infra:start      # Start infrastructure stack
npm run infra:stop       # Stop all services
npm run infra:restart    # Restart infrastructure
npm run infra:status     # Check service status
npm run infra:test       # Health check all services

# Advanced management
node scripts/infra-manager.js start     # Alternative start
node scripts/infra-manager.js status    # Detailed status
node scripts/infra-manager.js help      # Show all commands
```

### Docker Development

```bash
# Full Docker development
npm run docker:dev           # Start full stack
npm run docker:dev:stop      # Stop Docker stack
npm run docker:dev:logs      # View container logs
npm run docker:dev:restart   # Restart Docker stack

# Testing
npm run test:full           # Test all services
npm run sentry:test         # Test Sentry integration
```

### Application Development

```bash
# Development
pnpm dev                    # Start apps locally
pnpm build                  # Build for production
pnpm test                   # Run all tests
pnpm lint                   # Check code quality
pnpm lint:fix              # Auto-fix issues
```

---

## ⚙️ Configuration

### Environment Variables

Copy `env.example` to `.env` and configure:

```bash
# Sentry Configuration
SENTRY_DSN=your_sentry_dsn_here
SENTRY_ORG=your_organization
SENTRY_PROJECT=your_project

# Grafana Admin (optional)
GF_SECURITY_ADMIN_PASSWORD=your_secure_password

# OpenTelemetry
OTEL_SERVICE_NAME=handler
OTEL_EXPORTER_OTLP_ENDPOINT=http://localhost:8888

# Port Configuration
NODE_ENV=development     # Application environment
NEXT_PUBLIC_SENTRY_DSN=your-public-dsn # Client-side Sentry

# Port Configuration
WEB_PORT=3011           # Next.js application
SERVER_PORT=3012        # Express.js API
GRAFANA_PORT=3013       # Grafana dashboards
PROMETHEUS_PORT=9090    # Prometheus metrics

# Grafana Configuration
GRAFANA_PASSWORD=admin123 # Default: admin/admin
```

### Key Configuration Files

| File                               | Purpose                       |
| ---------------------------------- | ----------------------------- |
| `docker-compose.dev.yml`           | Full Docker development stack |
| `prometheus/prometheus.docker.yml` | Prometheus configuration      |
| `otel-collector-config.yml`        | OpenTelemetry collector setup |
| `.vscode/settings.json`            | VS Code auto-formatting       |
| `turbo.json`                       | Monorepo build pipeline       |

### Port Configuration

Default ports (configurable via environment variables):

```bash
WEB_PORT=3011           # Next.js application
SERVER_PORT=3012        # Express.js API
GRAFANA_PORT=3013       # Grafana dashboard
OTEL_PORT=8888          # OpenTelemetry collector
PROMETHEUS_PORT=9090    # Prometheus server
SENTRY_PORT=9000        # Sentry web interface
```

---

## 📊 Monitoring & Observability

### Application Metrics

Your applications automatically export metrics:

```typescript
// Example: Custom business metrics
import { prometheusRegister } from './metrics';

const orderCounter = new Counter({
  name: 'orders_total',
  help: 'Total number of orders processed',
  labelNames: ['status', 'type'],
});

orderCounter.inc({ status: 'completed', type: 'premium' });
```

### Distributed Tracing

OpenTelemetry automatically instruments:

- HTTP requests/responses
- Database queries
- External API calls
- Custom spans

### Error Tracking

Sentry integration captures:

- Unhandled exceptions
- Performance issues
- User feedback
- Release tracking

### Structured Logging

Winston provides structured logging:

```typescript
import logger from './logger';

logger.info('Order processed', {
  orderId: '12345',
  userId: 'user-456',
  amount: 99.99,
  duration: 1200,
});
```

---

## 🔧 Troubleshooting

### Common Issues

#### ❌ "Port already in use" errors

```bash
# Check what's using ports
lsof -i :3011 -i :3012 -i :9090

# Kill processes on specific ports
npm run infra:stop
# or manually:
kill -9 $(lsof -ti:3011)
```

#### ❌ "Docker containers not starting"

```bash
# Check Docker status
docker ps -a

# View container logs
docker logs container_name

# Restart Docker service
brew services restart docker  # macOS
sudo systemctl restart docker # Linux
```

#### ❌ "Prometheus targets down"

```bash
# Check if applications are running
curl http://localhost:3012/health
curl http://localhost:3011/api/health

# Verify Prometheus config
docker exec -it prometheus cat /etc/prometheus/prometheus.yml
```

#### ❌ "Grafana login issues"

```bash
# Reset Grafana admin password
docker exec -it grafana grafana-cli admin reset-admin-password newpassword
```

### Debug Commands

```bash
# View all running processes
npm run infra:status

# Test all endpoints
npm run infra:test

# View Docker logs
npm run docker:dev:logs

# Check individual services
curl http://localhost:9090/-/healthy  # Prometheus
curl http://localhost:3013/api/health # Grafana
curl http://localhost:8888/          # OpenTelemetry
```

### Performance Issues

```bash
# Check resource usage
docker stats

# View application logs
docker logs handler-web-dev
docker logs handler-server-dev

# Monitor file changes (for hot reload issues)
docker exec -it handler-web-dev ls -la /app
```

---

## 👥 Team Onboarding

### New Developer Setup (5 minutes)

```bash
# 1. Clone and install
git clone <repo-url> && cd handler
pnpm install

# 2. Copy environment template
cp env.example .env

# 3. Start development
npm run infra:start && pnpm dev

# 4. Verify setup
npm run infra:test
```

### VS Code Setup

The project includes VS Code settings for:

- ✅ Format on save (Prettier)
- ✅ ESLint auto-fix
- ✅ TypeScript strict mode
- ✅ Import sorting

### Git Workflow

Pre-commit hooks automatically:

- ✅ Run ESLint with auto-fix
- ✅ Format code with Prettier
- ✅ Type check with TypeScript
- ✅ Run tests on staged files

### Production Deployment

```bash
# Build and test locally
pnpm build
npm run test:full

# Deploy with Docker
docker-compose -f docker-compose.prod.yml up --build

# Monitor deployment
npm run infra:test
```

---

## 🎯 Best Practices

### Development Workflow

1. **Start with hybrid mode** for fast development
2. **Test with Docker mode** before pushing changes
3. **Monitor metrics** during development
4. **Use error tracking** to catch issues early

### Monitoring Best Practices

1. **Add custom metrics** for business logic
2. **Set up alerts** in Grafana for critical paths
3. **Use structured logging** for debugging
4. **Monitor performance** with OpenTelemetry

### Code Quality

1. **Format on save** is configured automatically
2. **ESLint rules** enforce best practices
3. **TypeScript strict mode** catches errors early
4. **Pre-commit hooks** ensure quality

### Infrastructure Management

1. **Use npm scripts** for consistent commands
2. **Check service status** before development
3. **Monitor resource usage** with Docker stats
4. **Clean up** with stop commands when done

---

## 🔗 External Resources

- [Prometheus Documentation](https://prometheus.io/docs/)
- [Grafana Documentation](https://grafana.com/docs/)
- [OpenTelemetry Documentation](https://opentelemetry.io/docs/)
- [Sentry Documentation](https://docs.sentry.io/)
- [Docker Compose Documentation](https://docs.docker.com/compose/)

---

## 🆘 Need Help?

1. **Check this guide** for common solutions
2. **Run diagnostics**: `npm run infra:test`
3. **View logs**: `npm run docker:dev:logs`
4. **Check GitHub issues** for known problems
5. **Ask your team** for infrastructure-specific help

---

_This infrastructure setup provides enterprise-grade monitoring and development experience. Happy coding! 🚀_
