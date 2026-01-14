/** @type {import('next').NextConfig} */
const nextConfig = {
  // Enable standalone output for Docker deployments
  output: 'standalone',

  // Recommended: disable x-powered-by header for security
  poweredByHeader: false,

  // Enable React strict mode for better development experience
  reactStrictMode: true,
};

module.exports = nextConfig;
