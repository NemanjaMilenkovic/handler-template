# Handler Monorepo

This is a monorepo containing a Next.js frontend and tRPC backend, built with TypeScript.

## Project Structure

- `apps/web` - Next.js frontend application
- `apps/server` - tRPC backend server
- `packages/eslint-config` - Shared ESLint configuration
- `packages/tsconfig` - Shared TypeScript configuration

## Prerequisites

- Node.js >= 18
- pnpm >= 8.15.4

## Getting Started

1. Install dependencies:

   ```bash
   pnpm install
   ```

2. Start the development servers:

   ```bash
   # Start both frontend and backend
   pnpm dev

   # Or start them separately
   pnpm --filter @handler/web dev
   pnpm --filter @handler/server dev
   ```

3. Open [http://localhost:3000](http://localhost:3000) in your browser.

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
