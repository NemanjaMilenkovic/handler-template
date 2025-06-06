import { QueryClient, QueryClientProvider } from '@tanstack/react-query';
import { httpBatchLink } from '@trpc/client';
import { useState } from 'react';
import superjson from 'superjson';
import type { AppRouter } from '@handler/server/src/router';

export default function App({ Component, pageProps }: any) {
  const [queryClient] = useState(() => new QueryClient());
  const [trpcClient] = useState(() =>
    httpBatchLink({
      url: 'http://localhost:3001/trpc',
      transformer: superjson,
    })
  );

  return (
    <QueryClientProvider client={queryClient}>
      <Component {...pageProps} />
    </QueryClientProvider>
  );
}
