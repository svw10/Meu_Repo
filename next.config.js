/** @type {import('next').NextConfig} */
const nextConfig = {
    reactStrictMode: true,
    swcMinify: true,

    // Otimizações de performance
    experimental: {
        optimizePackageImports: ['@prisma/client', 'inngest', 'zod'],
    },

    // Headers de segurança (LGPD & OWASP compliance)
    async headers() {
        return [
            {
                source: '/:path*',
                headers: [
                    {
                        key: 'X-Frame-Options',
                        value: 'DENY',
                    },
                    {
                        key: 'X-Content-Type-Options',
                        value: 'nosniff',
                    },
                    {
                        key: 'Referrer-Policy',
                        value: 'strict-origin-when-cross-origin',
                    },
                    {
                        key: 'Permissions-Policy',
                        value: 'camera=(), microphone=(), geolocation=()',
                    },
                ],
            },
        ];
    },
};

module.exports = nextConfig;
