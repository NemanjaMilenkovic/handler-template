import { createTRPCNext } from '@trpc/next';
import { httpBatchLink, loggerLink } from '@trpc/client';
import { inferRouterInputs, inferRouterOutputs } from '@trpc/server';
import type { AppRouter } from '@handler/api';
import superjson from 'superjson';

function getBaseUrl() {
  return '';
}

export const api = createTRPCNext<AppRouter>({
  config() {
    return {
      links: [
        loggerLink({
          enabled: opts =>
            process.env.NODE_ENV === 'development' ||
            (opts.direction === 'down' && opts.result instanceof Error),
        }),
        httpBatchLink({
          url: `${getBaseUrl()}/api/trpc`,
        }),
      ],
      transformer: superjson,
    };
  },
  ssr: false,
});

export type RouterInputs = inferRouterInputs<AppRouter>;
export type RouterOutputs = inferRouterOutputs<AppRouter>;
