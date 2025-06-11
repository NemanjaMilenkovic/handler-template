# Production-Grade Full-Stack Template

This is a template for building modern, robust, and observable full-stack applications. It provides a solid foundation with a Next.js frontend, a tRPC backend, and a complete suite of production-grade tools, all managed in a Turborepo monorepo.

The core philosophy is to provide end-to-end typesafety, a great developer experience, and out-of-the-box observability, allowing you to focus on building features, not boilerplate.

---

## What's Inside?

This template comes pre-configured with a modern technology stack.

### Core Frameworks

- **[Next.js](https://nextjs.org/)**: A complete React framework for the frontend.
- **[Express.js](https://expressjs.com/)**: A minimal and flexible Node.js framework for the backend server.
- **[tRPC](https://trpc.io/)**: For building end-to-end typesafe APIs without schemas or code generation. Your frontend can call your backend with full autocompletion and type safety.

### Tooling & Monorepo

- **[pnpm](https://pnpm.io/)**: A fast, disk space-efficient package manager.
- **[Turborepo](https://turbo.build/repo)**: A high-performance build system for monorepos, enabling fast, cached builds and tests.
- **[TypeScript](https://www.typescriptlang.org/)**: For static type-checking across the entire stack.
- **[ESLint](https://eslint.org/) & [Prettier](https://prettier.io/)**: For consistent code style, formatting, and automatic import sorting.

### Observability & Monitoring (The "O11y" Stack)

- **[OpenTelemetry](https://opentelemetry.io/)**: The standard for generating and collecting telemetry data (traces, metrics, logs).
- **[Prometheus](https://prometheus.io/)**: For collecting and storing time-series metrics from the backend.
- **[Grafana](https://grafana.com/)**: For visualizing metrics and creating dashboards.
- **[Sentry](https://sentry.io/)**: For real-time error reporting and performance monitoring.
- **[Winston](https://github.com/winstonjs/winston)**: For structured, production-ready logging, automatically correlated with OpenTelemetry traces.

### Testing & CI/CD

- **[Jest](https://jestjs.io/) & [React Testing Library](https://testing-library.com/docs/react-testing-library/intro/)**: For unit and component testing.
- **[GitHub Actions](https://github.com/features/actions)**: Pre-configured CI/CD workflows for building, testing, linting, and security scanning.
- **[CodeQL](https://codeql.github.com/)**: For automated static analysis and security vulnerability detection.

### Deployment

- **[Docker](https://www.docker.com/) & [Docker Compose](https://docs.docker.com/compose/)**: For containerizing the applications and running the entire stack in a production-like environment.

---

## Prerequisites

To use this template, you will need:

- **Node.js**: `v20.0.0` or higher (as defined in `.nvmrc`).
- **pnpm**: `v8.15.4` or higher (as defined in `package.json`).
- **Docker**: For running the production environment locally.

---

## Getting Started

1.  **Clone the repository & navigate to it:**
    ```bash
    git clone https://github.com/your-username/your-repo-name.git
    cd your-repo-name
    ```
2.  **Install all dependencies:**
    ```bash
    pnpm install
    ```
3.  **Run the development servers:**
    This command uses Turborepo to start the Next.js frontend and the Express backend concurrently.
    ```bash
    pnpm dev
    ```
    - The web app will be available at **[http://localhost:3000](http://localhost:3000)**.
    - The server will be running on **[http://localhost:3001](http://localhost:3001)**.

---

## Available Scripts

This monorepo is managed with Turborepo. You can run commands from the root directory.

- `pnpm dev`: Start all apps in development mode.
- `pnpm build`: Build all apps for production.
- `pnpm test`: Run tests across the monorepo.
- `pnpm lint`: Lint all code and check for issues.
- `pnpm format`: Format all code with Prettier.
- `pnpm clean`: Remove all build artifacts (`.next`, `dist`).
- `pnpm clean:full`: A full reset that removes all build artifacts, `node_modules`, and the `.turbo` cache.

---

## Running the Production Environment

You can spin up the entire production stack, including the observability tools, using Docker Compose.

1.  **Build and start all containers:**

    ```bash
    docker-compose -f docker-compose.prod.yml up --build
    ```

2.  **Access the services:**
    - **Web App**: [http://localhost:3000](http://localhost:3000)
    - **Server**: [http://localhost:3001](http://localhost:3001)
    - **Grafana**: [http://localhost:3002](http://localhost:3002)
    - **Prometheus**: [http://localhost:9090](http://localhost:9090)
