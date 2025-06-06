/** @type {import('next').NextConfig} */
const nextConfig = {
  reactStrictMode: true,
  transpilePackages: ["@handler/ui"],
  async rewrites() {
    return [
      {
        source: "/trpc/:path*",
        destination: "http://localhost:3001/trpc/:path*",
      },
    ];
  },
};

module.exports = nextConfig; 