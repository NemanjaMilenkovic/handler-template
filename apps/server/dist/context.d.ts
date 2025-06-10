import { inferAsyncReturnType } from '@trpc/server';
import { CreateExpressContextOptions } from '@trpc/server/adapters/express';
export declare const createContext: ({ req, res, }: CreateExpressContextOptions) => Promise<{
    req: CreateExpressContextOptions["req"];
    res: CreateExpressContextOptions["res"];
}>;
export type Context = inferAsyncReturnType<typeof createContext>;
//# sourceMappingURL=context.d.ts.map