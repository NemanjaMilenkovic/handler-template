import { createTRPCReact } from '@trpc/react-query';
import type { AppRouter } from '@handler/api';

export const trpc = createTRPCReact<AppRouter>();
