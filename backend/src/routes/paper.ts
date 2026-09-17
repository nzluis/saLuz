import type { FastifyInstance } from 'fastify';

import { esummary } from '../clients/pubmed.js';

export async function paperRoutes(app: FastifyInstance): Promise<void> {
  app.get<{
    Params: { id: string };
  }>('/api/paper/:id', async (request, reply) => {
    const { id } = request.params;

    if (!/^\d{1,8}$/.test(id)) {
      return reply.status(400).send({
        error: 'Bad Request',
        message: 'Invalid PubMed ID format.',
        statusCode: 400,
      });
    }

    try {
      const paper = await esummary(id);
      return reply.send(paper);
    } catch (error) {
      request.log.error(error);
      const message = error instanceof Error ? error.message : 'Unknown error';
      if (message.includes('not found')) {
        return reply.status(404).send({
          error: 'Not Found',
          message: `Paper ${id} not found.`,
          statusCode: 404,
        });
      }
      return reply.status(502).send({
        error: 'Bad Gateway',
        message: 'Failed to fetch paper from PubMed.',
        statusCode: 502,
      });
    }
  });
}
