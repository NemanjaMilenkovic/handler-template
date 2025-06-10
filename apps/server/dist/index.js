"use strict";
var __createBinding = (this && this.__createBinding) || (Object.create ? (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    var desc = Object.getOwnPropertyDescriptor(m, k);
    if (!desc || ("get" in desc ? !m.__esModule : desc.writable || desc.configurable)) {
      desc = { enumerable: true, get: function() { return m[k]; } };
    }
    Object.defineProperty(o, k2, desc);
}) : (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    o[k2] = m[k];
}));
var __setModuleDefault = (this && this.__setModuleDefault) || (Object.create ? (function(o, v) {
    Object.defineProperty(o, "default", { enumerable: true, value: v });
}) : function(o, v) {
    o["default"] = v;
});
var __importStar = (this && this.__importStar) || (function () {
    var ownKeys = function(o) {
        ownKeys = Object.getOwnPropertyNames || function (o) {
            var ar = [];
            for (var k in o) if (Object.prototype.hasOwnProperty.call(o, k)) ar[ar.length] = k;
            return ar;
        };
        return ownKeys(o);
    };
    return function (mod) {
        if (mod && mod.__esModule) return mod;
        var result = {};
        if (mod != null) for (var k = ownKeys(mod), i = 0; i < k.length; i++) if (k[i] !== "default") __createBinding(result, mod, k[i]);
        __setModuleDefault(result, mod);
        return result;
    };
})();
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
var express_1 = __importDefault(require("express"));
var cors_1 = __importDefault(require("cors"));
var express_2 = require("@trpc/server/adapters/express");
var router_1 = require("./router");
var context_1 = require("./context");
require("dotenv/config");
var Sentry = __importStar(require("@sentry/node"));
var errorHandler_1 = require("./middleware/errorHandler");
var security_1 = require("./middleware/security");
var metrics_1 = require("./middleware/metrics");
var gracefulShutdown_1 = require("./utils/gracefulShutdown");
var logger_1 = __importDefault(require("./utils/logger"));
var env_1 = __importDefault(require("./config/env"));
Sentry.init({ dsn: env_1.default.SENTRY_DSN });
var app = (0, express_1.default)();
// Apply middleware
(0, security_1.securityMiddleware)(app);
(0, metrics_1.metricsMiddleware)(app);
app.use((0, cors_1.default)());
// Health check endpoint
app.get('/health', function (_, res) {
    res.status(200).json({ status: 'ok' });
});
app.use('/trpc', (0, express_2.createExpressMiddleware)({
    router: router_1.appRouter,
    createContext: context_1.createContext,
}));
// Error handling middleware (should be last)
app.use(errorHandler_1.errorHandler);
var server = app.listen(env_1.default.PORT, function () {
    logger_1.default.info("Server listening on port ".concat(env_1.default.PORT));
});
// Setup graceful shutdown
(0, gracefulShutdown_1.gracefulShutdown)(server);
// test comment
// test comment
