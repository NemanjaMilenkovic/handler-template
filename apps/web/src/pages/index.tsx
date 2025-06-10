import { trpc } from '../utils/trpc';

export default function Home() {
  const { data, isLoading } = trpc.hello.useQuery({ name: 'from tRPC' });

  return (
    <main className="flex min-h-screen flex-col items-center justify-center p-24">
      <div className="z-10 max-w-5xl w-full items-center justify-between font-mono text-sm">
        <h1 className="text-4xl font-bold mb-8">Welcome to tRPC + Next.js</h1>
        <div className="bg-white/30 p-8 rounded-lg shadow-lg">
          <p className="text-xl">{isLoading ? 'Loading...' : data?.greeting}</p>
        </div>
      </div>
    </main>
  );
}
