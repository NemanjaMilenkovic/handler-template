/** @type {import('next').NextConfig} */
const nextConfig = {
  reactStrictMode: true,
  transpilePackages: ['@handler/ui'],
  async rewrites() {
    return [
      {
        source: '/api/trpc/:path*',
        destination: process.env.TRPC_URL_REWRITE || 'http://localhost:3012/trpc/:path*',
      },
    ];
  },
};

module.exports = nextConfig;
