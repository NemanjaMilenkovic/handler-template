import * as Sentry from '@sentry/node';
import { NextFunction, Request, Response } from 'express';

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

export const errorHandler = (
  err: Error | AppError,
  req: Request,
  res: Response,
  _next: NextFunction
) => {
  if (err instanceof AppError) {
    // Operational error - send to client
    return res.status(err.statusCode).json({
      status: 'error',
      message: err.message,
    });
  }

  // Programming or unknown error - don't leak error details
  console.error('ERROR 💥', err);
  Sentry.captureException(err);

  return res.status(500).json({
    status: 'error',
    message: 'Something went wrong',
  });
};
