import { describe, it, expect, vi, beforeAll, afterAll, beforeEach } from 'vitest';
import type { FastifyInstance } from 'fastify';

vi.mock('../src/clients/redis.js', () => ({
  redis: {},
  cacheGet: vi.fn().mockResolvedValue(null),
  cacheSet: vi.fn().mockResolvedValue(undefined),
  cacheDel: vi.fn().mockResolvedValue(undefined),
}));

const mockFetch = vi.fn();
vi.stubGlobal('fetch', mockFetch);

import { buildServer } from '../src/server.js';
import request from 'supertest';

let app: FastifyInstance;

beforeAll(async () => {
  app = await buildServer();
  await app.ready();
});

afterAll(async () => {
  await app.close();
});

beforeEach(() => {
  vi.clearAllMocks();
});

describe('GET /health', () => {
  it('returns ok', async () => {
    const res = await request(app.server).get('/health');
    expect(res.status).toBe(200);
    expect(res.body).toEqual({ status: 'ok' });
  });
});

describe('GET /api/search', () => {
  it('returns 400 when q is missing', async () => {
    const res = await request(app.server).get('/api/search');
    expect(res.status).toBe(400);
    expect(res.body.error).toBe('Bad Request');
  });

  it('returns 400 when q is empty', async () => {
    const res = await request(app.server).get('/api/search?q=');
    expect(res.status).toBe(400);
  });

  it('returns 400 when retmax is invalid', async () => {
    const res = await request(app.server).get('/api/search?q=test&retmax=200');
    expect(res.status).toBe(400);
    expect(res.body.message).toContain('retmax');
  });

  it('returns papers from PubMed', async () => {
    mockFetch
      .mockResolvedValueOnce({
        ok: true,
        json: async () => ({
          esearchresult: {
            count: '1',
            retmax: '1',
            retstart: '0',
            idlist: ['12345'],
            querykey: '1',
            webenv: 'env1',
          },
        }),
      })
      .mockResolvedValueOnce({
        ok: true,
        text: async () => `
          <PubmedArticle>
            <PubmedData><PMID Version="1">12345</PMID></PubmedData>
            <MedlineCitation>
              <Article>
                <ArticleTitle>Test</ArticleTitle>
                <Journal><Title>Journal</Title></Journal>
              </Article>
            </MedlineCitation>
          </PubmedArticle>
        `,
      });

    const res = await request(app.server).get('/api/search?q=cancer');
    expect(res.status).toBe(200);
    expect(res.body.count).toBe(1);
    expect(res.body.papers).toHaveLength(1);
  });

  it('returns 502 when PubMed fails', async () => {
    mockFetch.mockResolvedValue({ ok: false, status: 500 });

    const res = await request(app.server).get('/api/search?q=test');
    expect(res.status).toBe(502);
    expect(res.body.error).toBe('Bad Gateway');
  });
});

describe('GET /api/paper/:id', () => {
  it('returns 400 for invalid PMID', async () => {
    const res = await request(app.server).get('/api/paper/abc');
    expect(res.status).toBe(400);
    expect(res.body.message).toContain('Invalid PubMed ID');
  });

  it('returns paper details', async () => {
    mockFetch.mockResolvedValue({
      ok: true,
      json: async () => ({
        result: {
          uids: ['12345'],
          '12345': {
            uid: '12345',
            pubdate: '2024 Jan',
            authorstring: 'Smith J',
            title: 'Test Paper',
            source: 'TEST',
            fulljournalname: 'Test Journal',
            elocationid: 'doi: 10.1234/test',
            doistring: '10.1234/test',
            articlesinfluencedbycount: '0',
            availablefromurl: '',
            locationlabel: '',
            docsum: '',
          },
        },
      }),
    });

    const res = await request(app.server).get('/api/paper/12345');
    expect(res.status).toBe(200);
    expect(res.body.pmid).toBe('12345');
    expect(res.body.title).toBe('Test Paper');
  });

  it('returns 404 when paper not found', async () => {
    mockFetch.mockResolvedValue({
      ok: true,
      json: async () => ({ result: { uids: [] } }),
    });

    const res = await request(app.server).get('/api/paper/99999');
    expect(res.status).toBe(404);
  });

  it('returns 502 when PubMed fails', async () => {
    mockFetch.mockResolvedValue({ ok: false, status: 500 });

    const res = await request(app.server).get('/api/paper/12345');
    expect(res.status).toBe(502);
  });
});

describe('GET /api/related/:id', () => {
  it('returns 400 for invalid PMID', async () => {
    const res = await request(app.server).get('/api/related/abc');
    expect(res.status).toBe(400);
  });

  it('returns related papers', async () => {
    mockFetch.mockResolvedValue({
      ok: true,
      json: async () => ({
        linksets: [
          {
            linksetdbs: [
              {
                linkname: 'pubmed_pubmed',
                links: [
                  { score: '100', uid: '67890' },
                  { score: '50', uid: '11111' },
                ],
              },
            ],
          },
        ],
      }),
    });

    const res = await request(app.server).get('/api/related/12345');
    expect(res.status).toBe(200);
    expect(res.body.pmid).toBe('12345');
    expect(res.body.related).toHaveLength(2);
    expect(res.body.related[0].score).toBe(100);
  });

  it('returns 502 when PubMed fails', async () => {
    mockFetch.mockResolvedValue({ ok: false, status: 500 });

    const res = await request(app.server).get('/api/related/12345');
    expect(res.status).toBe(502);
  });
});
