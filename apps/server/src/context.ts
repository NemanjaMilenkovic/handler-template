import { inferAsyncReturnType } from '@trpc/server';
import { CreateExpressContextOptions } from '@trpc/server/adapters/express';

export const createContext = async ({
  req,
  res,
}: CreateExpressContextOptions): Promise<{
  req: CreateExpressContextOptions['req'];
  res: CreateExpressContextOptions['res'];
}> => {
  return {
    req,
    res,
  };
};

export type Context = inferAsyncReturnType<typeof createContext>;
