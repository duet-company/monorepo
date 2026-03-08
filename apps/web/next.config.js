/** @type {import('next').NextConfig} */
const nextConfig = {
  reactStrictMode: true,
  transpilePackages: ['@duet-company/ui', '@duet-company/shared', '@duet-company/config'],
};

module.exports = nextConfig;
