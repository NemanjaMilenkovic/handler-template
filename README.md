# Handler Monorepo

A modern, production-ready monorepo template for a Next.js frontend and tRPC backend, built with TypeScript.

## Project Structure

- `apps/web` - Next.js frontend application
- `apps/server` - tRPC backend server
- `packages/eslint-config` - Shared ESLint configuration
- `packages/tsconfig` - Shared TypeScript configuration

## Prerequisites

- Node.js >= 18
- pnpm >= 8.15.4

## Getting Started

1. **Clone the repository:**

   ```bash
   git clone <repository-url>
   cd handler
   ```

2. **Install dependencies:**

   ```bash
   pnpm install
   ```

3. **Start the development servers:**

   ```bash
   # Start both frontend and backend
   pnpm dev

   # Or start them separately
   pnpm --filter @handler/web dev
   pnpm --filter @handler/server dev
   ```

4. **Open [http://localhost:3000](http://localhost:3000) in your browser.**

## Available Scripts

- `pnpm dev` - Start all applications in development mode
- `pnpm build` - Build all applications
- `pnpm lint` - Run ESLint on all applications
- `pnpm format` - Format all files with Prettier

## Development

- Frontend runs on [http://localhost:3000](http://localhost:3000)
- Backend runs on [http://localhost:3001](http://localhost:3001)

## Tech Stack

- **Frontend**

  - Next.js
  - React
  - tRPC
  - TailwindCSS
  - TypeScript

- **Backend**

  - tRPC
  - Express
  - TypeScript
  - Zod

- **Development**
  - pnpm
  - Turborepo
  - ESLint
  - Prettier

## Production Deployment

- Docker and Docker Compose configurations are provided for production deployment.
- Run `docker-compose -f docker-compose.prod.yml up` to start the production environment.

## CI/CD

- GitHub Actions workflows for CI/CD are included in `.github/workflows/`.
- Automated linting, testing, and deployment pipelines are configured.

## Monitoring and Observability

- Prometheus and Grafana are configured for monitoring.
- OpenTelemetry is set up for distributed tracing.

## Security

- Security middleware (Helmet, rate limiting) is configured.
- Regular security scans are automated via GitHub Actions.

## License

[MIT](LICENSE)
