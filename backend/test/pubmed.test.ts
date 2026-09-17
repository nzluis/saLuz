import { describe, it, expect, vi, beforeEach } from 'vitest';

vi.mock('../src/clients/redis.js', () => {
  const cacheGet = vi.fn().mockResolvedValue(null);
  const cacheSet = vi.fn().mockResolvedValue(undefined);
  return { redis: {}, cacheGet, cacheSet };
});

const { cacheGet: mockRedisGet, cacheSet: mockRedisSet } = await import('../src/clients/redis.js');

const mockFetch = vi.fn();
vi.stubGlobal('fetch', mockFetch);

import { esearch, esummary, elink } from '../src/clients/pubmed.js';

beforeEach(() => {
  vi.clearAllMocks();
  mockRedisGet.mockResolvedValue(null);
});

describe('esearch', () => {
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
            webenv: 'test_webenv',
          },
        }),
      })
      .mockResolvedValueOnce({
        ok: true,
        text: async () => `
          <PubmedArticle>
            <PubmedData>
              <PMID Version="1">12345</PMID>
            </PubmedData>
            <MedlineCitation>
              <Article>
                <ArticleTitle>Test Article</ArticleTitle>
                <Journal><Title>Test Journal</Title></Journal>
                <Abstract><AbstractText>Test abstract</AbstractText></Abstract>
              </Article>
            </MedlineCitation>
          </PubmedArticle>
        `,
      });

    const result = await esearch('test query', 1);

    expect(result.count).toBe(1);
    expect(result.papers).toHaveLength(1);
    expect(result.papers[0].pmid).toBe('12345');
    expect(result.papers[0].title).toBe('Test Article');
  });

  it('returns cached result if available', async () => {
    const cached = { count: 1, papers: [], webenv: 'x', queryKey: '1' };
    mockRedisGet.mockResolvedValue(cached);

    const result = await esearch('cached query');
    expect(result).toEqual(cached);
    expect(mockFetch).not.toHaveBeenCalled();
  });
});

describe('esummary', () => {
  it('returns paper details', async () => {
    mockFetch.mockResolvedValue({
      ok: true,
      json: async () => ({
        result: {
          uids: ['12345'],
          '12345': {
            uid: '12345',
            pubdate: '2024 Jan',
            authorstring: 'Smith J, Doe A',
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

    const paper = await esummary('12345');

    expect(paper.pmid).toBe('12345');
    expect(paper.title).toBe('Test Paper');
    expect(paper.doi).toBe('10.1234/test');
    expect(paper.authors).toContain('Smith J');
  });

  it('returns cached result if available', async () => {
    const cached = { pmid: '12345', title: 'Cached' };
    mockRedisGet.mockResolvedValue(cached);

    const paper = await esummary('12345');
    expect(paper).toEqual(cached);
    expect(mockFetch).not.toHaveBeenCalled();
  });
});

describe('elink', () => {
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

    const result = await elink('12345');

    expect(result.pmid).toBe('12345');
    expect(result.related).toHaveLength(2);
    expect(result.related[0].pmid).toBe('67890');
    expect(result.related[0].score).toBe(100);
  });
});
