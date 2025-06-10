"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.appRouter = exports.publicProcedure = exports.router = void 0;
var server_1 = require("@trpc/server");
var zod_1 = require("zod");
var t = server_1.initTRPC.context().create();
exports.router = t.router;
exports.publicProcedure = t.procedure;
exports.appRouter = (0, exports.router)({
    hello: exports.publicProcedure.input(zod_1.z.object({ name: zod_1.z.string().optional() })).query(function (_a) {
        var _b;
        var input = _a.input;
        return {
            greeting: "Hello ".concat((_b = input.name) !== null && _b !== void 0 ? _b : 'world', "!"),
        };
    }),
});
