import express from 'express';
import cors from 'cors';
import { createExpressMiddleware } from '@trpc/server/adapters/express';
import { appRouter } from './router';
import { createContext } from './context';
import 'dotenv/config';
import * as Sentry from '@sentry/node';
import { errorHandler } from './middleware/errorHandler';
import { securityMiddleware } from './middleware/security';
import { metricsMiddleware } from './middleware/metrics';
import { gracefulShutdown } from './utils/gracefulShutdown';
import logger from './utils/logger';
import env from './config/env';

Sentry.init({ dsn: env.SENTRY_DSN });

const app = express();

// Apply middleware
securityMiddleware(app);
metricsMiddleware(app);
app.use(cors());

// Health check endpoint
app.get('/health', (_, res) => {
  res.status(200).json({ status: 'ok' });
});

app.use(
  '/trpc',
  createExpressMiddleware({
    router: appRouter,
    createContext,
  })
);

// Error handling middleware (should be last)
app.use(errorHandler);

const server = app.listen(env.PORT, () => {
  logger.info(`Server listening on port ${env.PORT}`);
});

// Setup graceful shutdown
gracefulShutdown(server);
// test comment
