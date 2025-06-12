import * as Sentry from '@sentry/node';
import { ErrorRequestHandler, NextFunction, Request, Response } from 'express';

export class AppError extends Error {
  constructor(
    public statusCode: number,
    public message: string,
    public isOperational = true
  ) {
    super(message);
    Object.setPrototypeOf(this, AppError.prototype);
  }
}

export const errorHandler: ErrorRequestHandler = (
  err: Error | AppError,
  req: Request,
  res: Response,
  _next: NextFunction
): void => {
  if (err instanceof AppError) {
    // Operational error - send to client
    res.status(err.statusCode).json({
      status: 'error',
      message: err.message,
    });
    return;
  }

  // Programming or unknown error - don't leak error details
  console.error('ERROR 💥', err);
  Sentry.captureException(err);

  res.status(500).json({
    status: 'error',
    message: 'Something went wrong',
  });
};
