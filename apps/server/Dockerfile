# Build stage
FROM node:20-alpine AS builder
WORKDIR /app

# Copy only the necessary package files
COPY package.json pnpm-lock.yaml ./
COPY pnpm-workspace.yaml ./

# Install pnpm
RUN npm install -g pnpm

# Install dependencies for the server app and its workspace dependencies
COPY apps/server/package.json ./apps/server/
COPY packages/api/package.json ./packages/api/
COPY packages/tsconfig/package.json ./packages/tsconfig/
COPY packages/eslint-config/package.json ./packages/eslint-config/
RUN pnpm install --frozen-lockfile --filter @handler/server...

# Copy the source code
COPY . .

# Build the server app
RUN pnpm --filter @handler/server build

# Production stage
FROM node:20-alpine AS runner
WORKDIR /app
COPY --from=builder /app/apps/server/dist ./dist
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/apps/server/package.json ./package.json

ENV NODE_ENV=production
EXPOSE 3012
CMD ["node", "dist/index.js"] 