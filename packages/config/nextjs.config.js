/** @type {import('next').NextConfig} */
module.exports = {
  reactStrictMode: true,
  transpilePackages: ['@duet-company/ui', '@duet-company/shared'],
  experimental: {
    optimizePackageImports: ['@duet-company/ui', '@duet-company/shared'],
  },
};
