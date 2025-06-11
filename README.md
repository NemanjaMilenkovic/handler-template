# Production-Grade Full-Stack Template

## What's Inside?

This template comes pre-configured with a modern technology stack.

### Core Frameworks

- **[Next.js](https://nextjs.org/)**
- **[Express.js](https://expressjs.com/)**
- **[tRPC](https://trpc.io/)**

### Tooling & Monorepo

- **[pnpm](https://pnpm.io/)**
- **[Turborepo](https://turbo.build/repo)**
- **[TypeScript](https://www.typescriptlang.org/)**
- **[ESLint](https://eslint.org/) & [Prettier](https://prettier.io/)**

### Observability & Monitoring (The "O11y" Stack)

- **[OpenTelemetry](https://opentelemetry.io/)**
- **[Prometheus](https://prometheus.io/)**
- **[Grafana](https://grafana.com/)**
- **[Sentry](https://sentry.io/)**
- **[Winston](https://github.com/winstonjs/winston)**

### Testing & CI/CD

- **[Jest](https://jestjs.io/) & [React Testing Library](https://testing-library.com/docs/react-testing-library/intro/)**
- **[GitHub Actions](https://github.com/features/actions)**
- **[CodeQL](https://codeql.github.com/)**

### Deployment

- **[Docker](https://www.docker.com/) & [Docker Compose](https://docs.docker.com/compose/)**

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
