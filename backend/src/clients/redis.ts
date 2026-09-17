import { Redis } from '@upstash/redis';

import { config } from '../config.js';

export const redis = new Redis({
  url: config.redis.url,
  token: config.redis.token,
});

export async function cacheGet<T>(key: string): Promise<T | null> {
  return redis.get<T>(key);
}

export async function cacheSet(
  key: string,
  value: unknown,
  ttlSeconds: number = 3600,
): Promise<void> {
  await redis.set(key, value, { ex: ttlSeconds });
}

export async function cacheDel(key: string): Promise<void> {
  await redis.del(key);
}
