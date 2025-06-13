import { api } from '../utils/trpc';

export default function Home() {
  const { data, isLoading } = api.hello.useQuery({ name: 'from tRPC' });

  return (
    <main className="flex min-h-screen flex-col items-center justify-center bg-gradient-to-b from-gray-900 to-black text-white">
      <div className="container flex flex-col items-center justify-center gap-12 px-4 py-16">
        <h1 className="text-4xl font-bold mb-8">Welcome to tRPC + Next.js</h1>
        <div className="bg-white/30 p-8 rounded-lg shadow-lg">
          <p className="text-xl">{isLoading ? 'Loading...' : data?.greeting}</p>
        </div>
      </div>
    </main>
  );
}
