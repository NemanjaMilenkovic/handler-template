import { createTRPCReact } from '@trpc/react-query';
import type { AppRouter } from '@handler/server/src/router';

export const trpc = createTRPCReact<AppRouter>();
