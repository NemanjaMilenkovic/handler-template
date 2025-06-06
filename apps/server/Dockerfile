# Build stage
FROM node:18-alpine AS builder
WORKDIR /app
COPY ../../package.json ../../pnpm-lock.yaml ./
COPY ../../packages ./packages
COPY . .
RUN npm install -g pnpm
RUN pnpm install --frozen-lockfile --filter @handler/server...
RUN pnpm --filter @handler/server build

# Production stage
FROM node:18-alpine AS runner
WORKDIR /app
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/package.json ./package.json

ENV NODE_ENV=production
EXPOSE 3001
CMD ["node", "dist/index.js"] 