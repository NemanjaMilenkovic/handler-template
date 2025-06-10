export declare const router: <TProcRouterRecord extends import("@trpc/server").ProcedureRouterRecord>(procedures: TProcRouterRecord) => import("@trpc/server").CreateRouterInner<import("@trpc/server").RootConfig<{
    ctx: {
        req: import("@trpc/server/adapters/express").CreateExpressContextOptions["req"];
        res: import("@trpc/server/adapters/express").CreateExpressContextOptions["res"];
    };
    meta: object;
    errorShape: import("@trpc/server").DefaultErrorShape;
    transformer: import("@trpc/server").DefaultDataTransformer;
}>, TProcRouterRecord>;
export declare const publicProcedure: import("@trpc/server").ProcedureBuilder<{
    _config: import("@trpc/server").RootConfig<{
        ctx: {
            req: import("@trpc/server/adapters/express").CreateExpressContextOptions["req"];
            res: import("@trpc/server/adapters/express").CreateExpressContextOptions["res"];
        };
        meta: object;
        errorShape: import("@trpc/server").DefaultErrorShape;
        transformer: import("@trpc/server").DefaultDataTransformer;
    }>;
    _ctx_out: {
        req: import("@trpc/server/adapters/express").CreateExpressContextOptions["req"];
        res: import("@trpc/server/adapters/express").CreateExpressContextOptions["res"];
    };
    _input_in: typeof import("@trpc/server").unsetMarker;
    _input_out: typeof import("@trpc/server").unsetMarker;
    _output_in: typeof import("@trpc/server").unsetMarker;
    _output_out: typeof import("@trpc/server").unsetMarker;
    _meta: object;
}>;
export declare const appRouter: import("@trpc/server").CreateRouterInner<import("@trpc/server").RootConfig<{
    ctx: {
        req: import("@trpc/server/adapters/express").CreateExpressContextOptions["req"];
        res: import("@trpc/server/adapters/express").CreateExpressContextOptions["res"];
    };
    meta: object;
    errorShape: import("@trpc/server").DefaultErrorShape;
    transformer: import("@trpc/server").DefaultDataTransformer;
}>, {
    hello: import("@trpc/server").BuildProcedure<"query", {
        _config: import("@trpc/server").RootConfig<{
            ctx: {
                req: import("@trpc/server/adapters/express").CreateExpressContextOptions["req"];
                res: import("@trpc/server/adapters/express").CreateExpressContextOptions["res"];
            };
            meta: object;
            errorShape: import("@trpc/server").DefaultErrorShape;
            transformer: import("@trpc/server").DefaultDataTransformer;
        }>;
        _meta: object;
        _ctx_out: {
            req: import("@trpc/server/adapters/express").CreateExpressContextOptions["req"];
            res: import("@trpc/server/adapters/express").CreateExpressContextOptions["res"];
        };
        _input_in: {
            name?: string | undefined;
        };
        _input_out: {
            name?: string | undefined;
        };
        _output_in: typeof import("@trpc/server").unsetMarker;
        _output_out: typeof import("@trpc/server").unsetMarker;
    }, {
        greeting: string;
    }>;
}>;
export type AppRouter = typeof appRouter;
//# sourceMappingURL=router.d.ts.map