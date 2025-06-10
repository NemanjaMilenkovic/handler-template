import { appRouter } from '../router';
import { createContext } from '../context';
import { CreateExpressContextOptions } from '@trpc/server/adapters/express';

describe('tRPC Router', () => {
  const mockContext: CreateExpressContextOptions = {
    req: {} as any,
    res: {} as any,
  };

  describe('hello procedure', () => {
    it('should return greeting with provided name', async () => {
      const ctx = await createContext(mockContext);
      const caller = appRouter.createCaller(ctx);
      const result = await caller.hello({ name: 'Test User' });
      expect(result).toEqual({
        greeting: 'Hello Test User!',
      });
    });

    it('should return greeting with default name when no name provided', async () => {
      const ctx = await createContext(mockContext);
      const caller = appRouter.createCaller(ctx);
      const result = await caller.hello({});
      expect(result).toEqual({
        greeting: 'Hello world!',
      });
    });
  });
});
