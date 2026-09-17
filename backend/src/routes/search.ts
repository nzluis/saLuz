import type { FastifyInstance } from 'fastify';

import { esearch } from '../clients/pubmed.js';

export async function searchRoutes(app: FastifyInstance): Promise<void> {
  app.get<{
    Querystring: { q: string; retmax?: string };
  }>('/api/search', async (request, reply) => {
    const { q, retmax } = request.query;

    if (!q || q.trim().length === 0) {
      return reply.status(400).send({
        error: 'Bad Request',
        message: 'Query parameter "q" is required.',
        statusCode: 400,
      });
    }

    const limit = retmax ? parseInt(retmax, 10) : 20;
    if (isNaN(limit) || limit < 1 || limit > 100) {
      return reply.status(400).send({
        error: 'Bad Request',
        message: 'Parameter "retmax" must be between 1 and 100.',
        statusCode: 400,
      });
    }

    try {
      const result = await esearch(q.trim(), limit);
      return reply.send(result);
    } catch (error) {
      request.log.error(error);
      return reply.status(502).send({
        error: 'Bad Gateway',
        message: 'Failed to fetch data from PubMed.',
        statusCode: 502,
      });
    }
  });
}
