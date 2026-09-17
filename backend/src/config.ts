import 'dotenv/config';

function requireEnv(name: string): string {
  const value = process.env[name];
  if (!value) {
    throw new Error(`Missing required environment variable: ${name}`);
  }
  return value;
}

export const config = {
  port: parseInt(process.env.PORT ?? '3000', 10),
  host: process.env.HOST ?? '0.0.0.0',
  pubmed: {
    baseUrl: process.env.PUBMED_BASE_URL ?? 'https://eutils.ncbi.nlm.nih.gov/entrez/eutils',
    apiKey: process.env.NCBI_API_KEY ?? '',
  },
  redis: {
    url: requireEnv('UPSTASH_REDIS_REST_URL'),
    token: requireEnv('UPSTASH_REDIS_REST_TOKEN'),
  },
  rateLimit: {
    max: parseInt(process.env.RATE_LIMIT_MAX ?? '10', 10),
    timeWindow: process.env.RATE_LIMIT_WINDOW ?? '1 second',
  },
} as const;
