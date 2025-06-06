# Build stage
FROM node:18-alpine AS builder
WORKDIR /app
COPY ../../package.json ../../pnpm-lock.yaml ./
COPY ../../packages ./packages
COPY . .
RUN npm install -g pnpm
RUN pnpm install --frozen-lockfile --filter @handler/web...
RUN pnpm --filter @handler/web build

# Production stage
FROM node:18-alpine AS runner
WORKDIR /app
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/public ./public
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/package.json ./package.json

ENV NODE_ENV=production
EXPOSE 3000
CMD ["node", ".next/standalone/server.js"] 