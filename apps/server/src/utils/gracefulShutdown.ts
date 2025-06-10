import { Server } from 'http';

import logger from './logger';

export const gracefulShutdown = (server: Server) => {
  const shutdown = async () => {
    logger.info('Received shutdown signal');

    // Stop accepting new connections
    server.close(() => {
      logger.info('Server closed');
      process.exit(0);
    });

    // Force close after 10s
    setTimeout(() => {
      logger.error('Could not close connections in time, forcefully shutting down');
      process.exit(1);
    }, 10000);
  };

  process.on('SIGTERM', shutdown);
  process.on('SIGINT', shutdown);

  // Handle uncaught exceptions
  process.on('uncaughtException', error => {
    logger.error('Uncaught Exception:', error);
    shutdown();
  });

  // Handle unhandled promise rejections
  process.on('unhandledRejection', reason => {
    logger.error('Unhandled Rejection:', reason);
    shutdown();
  });
};
