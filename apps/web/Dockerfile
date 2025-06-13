# Build stage
FROM node:20-alpine AS builder
WORKDIR /app

# Copy only the necessary package files
COPY package.json pnpm-lock.yaml ./
COPY pnpm-workspace.yaml ./

# Install pnpm
RUN npm install -g pnpm

# Install dependencies for the web app and its workspace dependencies
COPY apps/web/package.json ./apps/web/
COPY packages/api/package.json ./packages/api/
COPY packages/tsconfig/package.json ./packages/tsconfig/
COPY packages/eslint-config/package.json ./packages/eslint-config/
RUN pnpm install --frozen-lockfile --filter @handler/web...

# Copy the source code
COPY . .

# Build the web app
RUN pnpm --filter @handler/web build

# Production stage
FROM node:20-alpine AS runner
WORKDIR /app
COPY --from=builder /app/apps/web/.next ./.next
COPY --from=builder /app/public ./public
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/apps/web/package.json ./package.json

ENV NODE_ENV=production
EXPOSE 3011
CMD ["node", ".next/standalone/server.js"] 