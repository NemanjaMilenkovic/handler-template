import * as Sentry from '@sentry/nextjs';
import type { AppProps } from 'next/app';
import Head from 'next/head';
import { api } from '../utils/trpc';

import { ErrorBoundary } from '../components/ErrorBoundary';

Sentry.init({ dsn: process.env.NEXT_PUBLIC_SENTRY_DSN });

function MyApp({ Component, pageProps }: AppProps) {
  return (
    <ErrorBoundary>
      <Head>
        <title>Handler App</title>
        <meta name="description" content="A modern web application built with Next.js and tRPC" />
        <link rel="icon" href="/favicon.ico" />
      </Head>
      <main>
        <Component {...pageProps} />
      </main>
    </ErrorBoundary>
  );
}

export default api.withTRPC(MyApp);
