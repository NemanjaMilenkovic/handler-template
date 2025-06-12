# Handler - Production-Grade Full-Stack Template

A comprehensive full-stack TypeScript template with enterprise-grade infrastructure, monitoring, and development tooling.

## 🚀 What's Inside?

### Core Application Stack

- **[Next.js 15](https://nextjs.org/)** - React framework with App Router
- **[Express.js](https://expressjs.com/)** - Node.js web framework
- **[tRPC](https://trpc.io/)** - End-to-end type-safe APIs
- **[TypeScript](https://www.typescriptlang.org/)** - Type safety across the stack

### Monorepo & Tooling

- **[pnpm](https://pnpm.io/)** - Fast, disk space efficient package manager
- **[Turborepo](https://turbo.build/repo)** - High-performance monorepo build system
- **[ESLint](https://eslint.org/) & [Prettier](https://prettier.io/)** - Code linting and formatting
- **[lint-staged](https://github.com/okonet/lint-staged)** - Git hooks for quality gates

### Enterprise Infrastructure

- **[OpenTelemetry](https://opentelemetry.io/)** - Distributed tracing and metrics
- **[Prometheus](https://prometheus.io/)** - Metrics collection and monitoring
- **[Grafana](https://grafana.com/)** - Observability dashboards
- **[Sentry](https://sentry.io/)** - Error tracking and performance monitoring
- **[Winston](https://github.com/winstonjs/winston)** - Structured logging

### Testing & CI/CD

- **[Jest](https://jestjs.io/)** - JavaScript testing framework
- **[React Testing Library](https://testing-library.com/)** - React component testing
- **[SWC](https://swc.rs/)** - Fast TypeScript/JavaScript compiler
- **[GitHub Actions](https://github.com/features/actions)** - CI/CD pipeline
- **[CodeQL](https://codeql.github.com/)** - Security analysis

### Deployment & Containerization

- **[Docker](https://www.docker.com/)** - Application containerization
- **[Docker Compose](https://docs.docker.com/compose/)** - Multi-container orchestration

---

## 📋 Prerequisites

- **Node.js**: `v20.0.0` or higher (defined in `.nvmrc`)
- **pnpm**: `v8.15.4` or higher (defined in `package.json`)
- **Docker & Docker Compose**: For infrastructure and containerized development

---

## 🏁 Quick Start

### 1. Clone and Install

```bash
git clone <your-repo-url>
cd handler
pnpm install
```

### 2. Choose Your Development Mode

#### Option A: Hybrid Development (Recommended)

Infrastructure in Docker, applications running locally for fast hot-reloading:

```bash
# Start infrastructure (Prometheus, Grafana, etc.)
npm run infra:start

# Start development servers
pnpm dev

# Test everything is working
npm run infra:test
```

#### Option B: Full Docker Development

Everything containerized including your applications:

```bash
# Start full Docker stack
npm run docker:dev

# Test everything including Sentry
npm run test:full
```

### 3. Access Your Services

- **Web App**: [http://localhost:3000](http://localhost:3000)
- **API Server**: [http://localhost:3001](http://localhost:3001)
- **Grafana**: [http://localhost:3002](http://localhost:3002) (admin/admin)
- **Prometheus**: [http://localhost:9090](http://localhost:9090)

---

## 🛠 Available Scripts

### Core Development

- `pnpm dev` - Start all applications in development mode
- `pnpm build` - Build all applications for production
- `pnpm test` - Run all tests across the monorepo
- `pnpm lint` - Lint all code
- `pnpm lint:fix` - Auto-fix linting issues
- `pnpm format` - Format code with Prettier

### Infrastructure Management

- `npm run infra:start` - Start infrastructure stack (hybrid mode)
- `npm run infra:stop` - Stop all infrastructure services
- `npm run infra:restart` - Restart infrastructure stack
- `npm run infra:status` - Check infrastructure status
- `npm run infra:test` - Test all infrastructure endpoints

### Docker Development

- `npm run docker:dev` - Start full Docker development stack
- `npm run docker:dev:stop` - Stop Docker development stack
- `npm run docker:dev:logs` - View Docker container logs
- `npm run docker:dev:restart` - Restart Docker development stack

### Testing & Quality

- `npm run test:full` - Test full infrastructure including Sentry
- `npm run sentry:test` - Test Sentry error tracking
- `pnpm clean` - Remove build artifacts
- `pnpm clean:full` - Full reset (build artifacts + node_modules + cache)

---

## 📊 Infrastructure Services

| Service       | Port | Description                            |
| ------------- | ---- | -------------------------------------- |
| Web App       | 3000 | Next.js frontend application           |
| API Server    | 3001 | Express.js backend with tRPC           |
| Grafana       | 3002 | Monitoring dashboards                  |
| OpenTelemetry | 8888 | Telemetry data collector               |
| Prometheus    | 9090 | Metrics storage and querying           |
| Sentry Web    | 9000 | Error tracking dashboard (Docker mode) |

---

## 🔧 Development Workflows

### Day-to-Day Development

1. **Start infrastructure**: `npm run infra:start`
2. **Start development**: `pnpm dev`
3. **Make changes** with auto-formatting and hot reloading
4. **Test changes**: `pnpm test` and `npm run infra:test`

### Testing Infrastructure Changes

1. **Full Docker mode**: `npm run docker:dev`
2. **Test everything**: `npm run test:full`
3. **Check logs**: `npm run docker:dev:logs`

### Before Commits

Automated via git hooks:

- ESLint auto-fixing
- Prettier formatting
- Type checking
- Tests on staged files

---

## 📝 Configuration Files

### Key Configuration

- `turbo.json` - Turborepo pipeline configuration
- `.vscode/settings.json` - VS Code format-on-save settings
- `docker-compose.dev.yml` - Full Docker development stack
- `prometheus/prometheus.docker.yml` - Prometheus configuration
- `otel-collector-config.yml` - OpenTelemetry collector setup

### Environment Variables

Copy `env.example` to `.env` and configure:

- Sentry DSN and organization settings
- Grafana admin credentials
- OpenTelemetry configuration

---

## 🏗 Architecture

This is a monorepo with the following structure:

```
├── apps/
│   ├── web/          # Next.js frontend
│   └── server/       # Express.js backend
├── packages/
│   ├── api/          # Shared tRPC API definitions
│   ├── eslint-config/# Shared ESLint configuration
│   └── tsconfig/     # Shared TypeScript configs
├── scripts/          # Infrastructure management scripts
└── prometheus/       # Prometheus configuration
```

---

## 🔍 Monitoring & Observability

### Metrics & Dashboards

- **Prometheus** collects metrics from your applications
- **Grafana** provides visualization dashboards
- **OpenTelemetry** handles distributed tracing

### Error Tracking

- **Sentry** captures and tracks application errors
- Test error endpoint: `GET /test-error` on the server

### Logging

- **Winston** provides structured logging
- Logs are collected by OpenTelemetry collector

---

## 🤝 Contributing

1. **Code Style**: Enforced automatically via ESLint and Prettier
2. **Testing**: All tests must pass before commits
3. **Type Safety**: Full TypeScript coverage required
4. **Documentation**: Update docs for infrastructure changes

---

## 📚 Learn More

- [Full Infrastructure Guide](./INFRASTRUCTURE.md) - Comprehensive setup and troubleshooting
- [Next.js Documentation](https://nextjs.org/docs)
- [tRPC Documentation](https://trpc.io/docs)
- [Turborepo Documentation](https://turbo.build/repo/docs)

---

## 🚀 Deployment

### Production Build

```bash
pnpm build
docker-compose -f docker-compose.prod.yml up --build
```

### Environment Setup

1. Copy `env.example` to `.env.production`
2. Configure production environment variables
3. Set up external monitoring services (Sentry, etc.)

---

_Built with ❤️ for enterprise-grade development_
