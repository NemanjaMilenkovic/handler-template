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

### Development Mode (Recommended)

1. **Install dependencies**:

   ```bash
   pnpm install
   ```

2. **Start infrastructure** (Prometheus, Grafana):

   ```bash
   npm run infra:start
   ```

3. **Start development servers**:

   ```bash
   pnpm dev
   ```

4. **Access your application**:
   - **Web App**: [http://localhost:3011](http://localhost:3011)
   - **API Server**: [http://localhost:3012](http://localhost:3012)
   - **Prometheus**: [http://localhost:9090](http://localhost:9090)
   - **Grafana**: [http://localhost:3013](http://localhost:3013) (admin/admin)

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

- **Web App**: [http://localhost:3011](http://localhost:3011)
- **API Server**: [http://localhost:3012](http://localhost:3012)
- **Grafana**: [http://localhost:3013](http://localhost:3013) (admin/admin)
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

| Service    | Port | Description                       |
| ---------- | ---- | --------------------------------- |
| Web App    | 3011 | Next.js frontend application      |
| API Server | 3012 | Express.js backend with tRPC      |
| Prometheus | 9090 | Metrics collection and monitoring |
| Grafana    | 3013 | Dashboards and visualization      |
| Sentry     | 9000 | Error tracking (Docker mode only) |

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
