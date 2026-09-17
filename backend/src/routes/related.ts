import type { FastifyInstance } from 'fastify';

import { elink } from '../clients/pubmed.js';

export async function relatedRoutes(app: FastifyInstance): Promise<void> {
  app.get<{
    Params: { id: string };
    Querystring: { retmax?: string };
  }>('/api/related/:id', async (request, reply) => {
    const { id } = request.params;
    const { retmax } = request.query;

    if (!/^\d{1,8}$/.test(id)) {
      return reply.status(400).send({
        error: 'Bad Request',
        message: 'Invalid PubMed ID format.',
        statusCode: 400,
      });
    }

    const limit = retmax ? parseInt(retmax, 10) : 10;
    if (isNaN(limit) || limit < 1 || limit > 50) {
      return reply.status(400).send({
        error: 'Bad Request',
        message: 'Parameter "retmax" must be between 1 and 50.',
        statusCode: 400,
      });
    }

    try {
      const result = await elink(id, limit);
      return reply.send(result);
    } catch (error) {
      request.log.error(error);
      return reply.status(502).send({
        error: 'Bad Gateway',
        message: 'Failed to fetch related papers from PubMed.',
        statusCode: 502,
      });
    }
  });
}
