import * as Sentry from '@sentry/nextjs';
import { QueryClient, QueryClientProvider } from '@tanstack/react-query';
import { httpBatchLink } from '@trpc/client';
import type { AppProps } from 'next/app';
import Head from 'next/head';
import { useState } from 'react';

import { ErrorBoundary } from '../components/ErrorBoundary';
import { trpc } from '../utils/trpc';

Sentry.init({ dsn: process.env.NEXT_PUBLIC_SENTRY_DSN });

function App({ Component, pageProps }: AppProps) {
  const [queryClient] = useState(
    () =>
      new QueryClient({
        defaultOptions: {
          queries: {
            retry: 1,
            refetchOnWindowFocus: false,
          },
        },
      }) as QueryClient
  );
  const [trpcClient] = useState(() =>
    trpc.createClient({
      links: [
        httpBatchLink({
          url: 'http://localhost:3001/trpc',
        }),
      ],
    })
  );

  return (
    <ErrorBoundary>
      <Head>
        <title>Handler App</title>
        <meta name="description" content="A modern web application built with Next.js and tRPC" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <link rel="icon" href="/favicon.ico" />
      </Head>
      <trpc.Provider client={trpcClient} queryClient={queryClient}>
        <QueryClientProvider client={queryClient}>
          <Component {...pageProps} />
        </QueryClientProvider>
      </trpc.Provider>
    </ErrorBoundary>
  );
}

export default App;
