import { defineConfig } from 'vitest/config';
import { config as loadEnv } from 'dotenv';
import { resolve } from 'path';

loadEnv({ path: resolve(__dirname, '../.env') });

export default defineConfig({
  test: {
    globals: true,
    environment: 'node',
    coverage: {
      provider: 'v8',
      include: ['src/**/*.ts'],
      exclude: ['src/index.ts', 'src/types/**'],
      thresholds: {
        statements: 80,
        branches: 70,
        functions: 70,
        lines: 80,
      },
    },
  },
});
