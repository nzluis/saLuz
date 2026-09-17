import cors from '@fastify/cors';
import swagger from '@fastify/swagger';
import swaggerUi from '@fastify/swagger-ui';
import Fastify from 'fastify';

import { rateLimitPlugin } from './plugins/rate-limit.js';
import { paperRoutes } from './routes/paper.js';
import { relatedRoutes } from './routes/related.js';
import { searchRoutes } from './routes/search.js';

export async function buildServer() {
  const app = Fastify({
    logger: {
      level: process.env.LOG_LEVEL ?? 'info',
    },
  });

  await app.register(cors, { origin: true });
  await app.register(swagger, {
    openapi: {
      info: {
        title: 'saLuz API',
        description: 'PubMed data API for saLuz health education app',
        version: '0.1.0',
      },
      servers: [{ url: 'http://localhost:3000' }],
    },
  });
  await app.register(swaggerUi, { routePrefix: '/docs' });
  await app.register(rateLimitPlugin);

  await app.register(searchRoutes);
  await app.register(paperRoutes);
  await app.register(relatedRoutes);

  app.get('/health', async () => ({ status: 'ok' }));

  return app;
}
