import 'dotenv/config';

import * as Sentry from '@sentry/node';
import { createExpressMiddleware } from '@trpc/server/adapters/express';
import cors from 'cors';
import express from 'express';

import env from './config/env';
import { createContext } from './context';
import { errorHandler } from './middleware/errorHandler';
import { metricsMiddleware } from './middleware/metrics';
import { securityMiddleware } from './middleware/security';
import { appRouter } from './router';
import { gracefulShutdown } from './utils/gracefulShutdown';
import logger from './utils/logger';

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

// Test error endpoint for Sentry testing
app.get('/test-error', (_, _res) => {
  logger.error('Test error endpoint triggered');
  throw new Error('This is a test error for Sentry verification');
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
