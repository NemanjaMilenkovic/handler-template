"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
var winston_1 = __importDefault(require("winston"));
var api_1 = require("@opentelemetry/api");
var otelFormat = winston_1.default.format(function (info) {
    var span = api_1.trace.getSpan(api_1.context.active());
    if (span) {
        var spanContext = span.spanContext();
        info.traceId = spanContext.traceId;
        info.spanId = spanContext.spanId;
    }
    return info;
});
var logger = winston_1.default.createLogger({
    level: process.env.LOG_LEVEL || 'info',
    format: winston_1.default.format.combine(winston_1.default.format.timestamp(), otelFormat(), winston_1.default.format.json()),
    defaultMeta: { service: 'api' },
    transports: [
        new winston_1.default.transports.Console({
            format: winston_1.default.format.combine(winston_1.default.format.colorize(), winston_1.default.format.simple()),
        }),
    ],
});
if (process.env.NODE_ENV === 'production') {
    logger.add(new winston_1.default.transports.File({ filename: 'error.log', level: 'error' }));
    logger.add(new winston_1.default.transports.File({ filename: 'combined.log' }));
}
exports.default = logger;
