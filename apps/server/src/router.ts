import { initTRPC } from '@trpc/server';
import { z } from 'zod';
import { Context } from './context';
import { createTRPCReact } from '@trpc/react-query';
import type { AppRouter } from '@handler/api';

const t = initTRPC.context<Context>().create();

export const router = t.router;
export const publicProcedure = t.procedure;

export const appRouter = router({
  hello: publicProcedure.input(z.object({ name: z.string().optional() })).query(({ input }) => {
    return {
      greeting: `Hello ${input.name ?? 'world'}!`,
    };
  }),
});

export type AppRouter = typeof appRouter;

export const trpc = createTRPCReact<AppRouter>();
