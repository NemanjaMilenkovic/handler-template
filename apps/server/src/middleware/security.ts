import rateLimit from 'express-rate-limit';
import helmet from 'helmet';
import { Express } from 'express';
import compression from 'compression';
import { v4 as uuidv4 } from 'uuid';

export const securityMiddleware = (app: Express) => {
  // Rate limiting
  const limiter = rateLimit({
    windowMs: 15 * 60 * 1000, // 15 minutes
    max: 100, // Limit each IP to 100 requests per windowMs
    message: 'Too many requests from this IP, please try again later.',
  });

  // Apply security middleware
  app.use(helmet()); // Security headers
  app.use(limiter); // Rate limiting
  app.use(compression()); // Enable compression
  app.use((req, res, next) => {
    // Add request ID for tracking
    req.id = uuidv4();
    res.setHeader('X-Request-ID', req.id);

    // Security headers
    res.setHeader('X-Content-Type-Options', 'nosniff');
    res.setHeader('X-Frame-Options', 'DENY');
    res.setHeader('X-XSS-Protection', '1; mode=block');
    next();
  });
};
