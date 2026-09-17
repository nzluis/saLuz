import { config } from '../config.js';
import { cacheGet, cacheSet } from './redis.js';

import type {
  ELinkResponse,
  ESearchResponse,
  ESummaryResponse,
  PaperDetail,
  PubMedArticle,
  RelatedPapers,
  SearchResult,
} from '../types/pubmed.js';

const BASE = config.pubmed.apiKey
  ? `${config.pubmed.baseUrl}?api_key=${config.pubmed.apiKey}`
  : config.pubmed.baseUrl;

const CACHE_TTL = 3600;

function buildAbstract(article: Record<string, unknown>): string {
  const medline = article['MedlineCitation'] as Record<string, unknown> | undefined;
  const art = medline?.['Article'] as Record<string, unknown> | undefined;
  const abstract = art?.['Abstract'] as Record<string, unknown> | undefined;
  const abstractText = abstract?.['AbstractText'];
  if (!abstractText) return '';
  if (Array.isArray(abstractText)) return abstractText.join(' ');
  return String(abstractText);
}

function extractAuthors(article: Record<string, unknown>): string[] {
  const medline = article['MedlineCitation'] as Record<string, unknown> | undefined;
  const art = medline?.['Article'] as Record<string, unknown> | undefined;
  const authorList = art?.['AuthorList'] as Array<Record<string, unknown>> | undefined;
  if (!authorList) return [];
  return authorList.map((a) => {
    const last = (a['LastName'] as string) ?? '';
    const first = (a['ForeName'] as string) ?? '';
    return [last, first].filter(Boolean).join(' ');
  }).filter(Boolean);
}

export async function esearch(
  term: string,
  retmax: number = 20,
): Promise<SearchResult> {
  const cacheKey = `esearch:${term}:${retmax}`;
  const cached = await cacheGet<SearchResult>(cacheKey);
  if (cached) return cached;

  const params = new URLSearchParams({
    db: 'pubmed',
    term,
    retmax: String(retmax),
    retmode: 'json',
    sort: 'relevance',
  });

  const res = await fetch(`${BASE}/esearch.fcgi?${params}`);
  if (!res.ok) {
    throw new Error(`PubMed esearch failed: ${res.status}`);
  }

  const data = (await res.json()) as ESearchResponse;
  const result = data.esearchresult;
  const ids = result.idlist;

  if (ids.length === 0) {
    return { count: 0, papers: [], webenv: result.webenv, queryKey: result.querykey };
  }

  const papers = await efetchBatch(result.webenv, result.querykey, 0, ids.length);

  const searchResult: SearchResult = {
    count: parseInt(result.count, 10),
    papers,
    webenv: result.webenv,
    queryKey: result.querykey,
  };

  await cacheSet(cacheKey, searchResult, CACHE_TTL);
  return searchResult;
}

async function efetchBatch(
  webenv: string,
  queryKey: string,
  retstart: number,
  retmax: number,
): Promise<PubMedArticle[]> {
  const cacheKey = `efetch:${webenv}:${queryKey}:${retstart}:${retmax}`;
  const cached = await cacheGet<PubMedArticle[]>(cacheKey);
  if (cached) return cached;

  const params = new URLSearchParams({
    db: 'pubmed',
    query_key: queryKey,
    WebEnv: webenv,
    retmode: 'xml',
    rettype: 'abstract',
    retstart: String(retstart),
    retmax: String(retmax),
  });

  const res = await fetch(`${BASE}/efetch.fcgi?${params}`);
  if (!res.ok) {
    throw new Error(`PubMed efetch failed: ${res.status}`);
  }

  const text = await res.text();
  const articles = parsePubmedXml(text);

  await cacheSet(cacheKey, articles, CACHE_TTL);
  return articles;
}

function parsePubmedXml(xml: string): PubMedArticle[] {
  const articles: PubMedArticle[] = [];
  const articleBlocks = xml.split('<PubmedArticle>').slice(1);

  for (const block of articleBlocks) {
    const pmidMatch = block.match(/<PMID[^>]*>(\d+)<\/PMID>/);
    const titleMatch = block.match(/<ArticleTitle>([\s\S]*?)<\/ArticleTitle>/);
    const journalMatch = block.match(/<Title>([\s\S]*?)<\/Title>/);
    const pubDateMatch = block.match(/<PubDate>([\s\S]*?)<\/PubDate>/);
    const doiMatch = block.match(/<ArticleId IdType="doi">([\s\S]*?)<\/ArticleId>/);

    const authors: string[] = [];
    const authorBlocks = block.split('<Author>').slice(1);
    for (const ab of authorBlocks) {
      const lastMatch = ab.match(/<LastName>([\s\S]*?)<\/LastName>/);
      const foreMatch = ab.match(/<ForeName>([\s\S]*?)<\/ForeName>/);
      if (lastMatch?.[1]) {
        authors.push([lastMatch[1], foreMatch?.[1] ?? ''].filter(Boolean).join(' '));
      }
    }

    const abstractParts: string[] = [];
    const abstractBlocks = block.split('<AbstractText').slice(1);
    for (const abs of abstractBlocks) {
      const labelMatch = abs.match(/Label="([\s\S]*?)"/);
      const textMatch = abs.match(/>([\s\S]*?)<\/AbstractText>/);
      if (textMatch?.[1]) {
        const label = labelMatch?.[1] ? `${labelMatch[1]}: ` : '';
        abstractParts.push(label + textMatch[1].replace(/<\/?[^>]+>/g, ''));
      }
    }

    const pubDate = pubDateMatch?.[1]
      ?.replace(/<[^>]+>/g, '')
      .trim() ?? '';

    if (pmidMatch?.[1]) {
      articles.push({
        pmid: pmidMatch[1],
        title: titleMatch?.[1]?.replace(/<\/?[^>]+>/g, '').trim() ?? '',
        authors,
        journal: journalMatch?.[1]?.trim() ?? '',
        pubDate,
        doi: doiMatch?.[1] ?? null,
        abstract: abstractParts.join('\n\n'),
      });
    }
  }

  return articles;
}

export async function esummary(pmid: string): Promise<PaperDetail> {
  const cacheKey = `esummary:${pmid}`;
  const cached = await cacheGet<PaperDetail>(cacheKey);
  if (cached) return cached;

  const params = new URLSearchParams({
    db: 'pubmed',
    id: pmid,
    retmode: 'json',
  });

  const res = await fetch(`${BASE}/esummary.fcgi?${params}`);
  if (!res.ok) {
    throw new Error(`PubMed esummary failed: ${res.status}`);
  }

  const data = (await res.json()) as ESummaryResponse;
  const result = data.result[pmid];
  if (!result) {
    throw new Error(`Paper not found: ${pmid}`);
  }

  const authors = result.authorstring
    ?.split(', ')
    .map((a) => a.trim())
    .filter(Boolean) ?? [];

  const detail: PaperDetail = {
    pmid,
    title: result.title,
    authors,
    journal: result.fulljournalname,
    pubDate: result.pubdate,
    doi: result.doistring,
    abstract: '',
  };

  await cacheSet(cacheKey, detail, CACHE_TTL);
  return detail;
}

export async function elink(pmid: string, retmax: number = 10): Promise<RelatedPapers> {
  const cacheKey = `elink:${pmid}:${retmax}`;
  const cached = await cacheGet<RelatedPapers>(cacheKey);
  if (cached) return cached;

  const params = new URLSearchParams({
    dbfrom: 'pubmed',
    db: 'pubmed',
    id: pmid,
    retmode: 'json',
    relatest: 'pubmed_pubmed',
    retmax: String(retmax),
    sort: 'score',
  });

  const res = await fetch(`${BASE}/elink.fcgi?${params}`);
  if (!res.ok) {
    throw new Error(`PubMed elink failed: ${res.status}`);
  }

  const data = (await res.json()) as ELinkResponse;
  const linkset = data.linksets[0];
  const linksetDb = linkset?.linksetdbs?.find(
    (db) => db.linkname === 'pubmed_pubmed',
  );

  const related = (linksetDb?.links ?? [])
    .map((link) => ({
      pmid: link.uid,
      score: parseInt(link.score, 10),
    }))
    .sort((a, b) => b.score - a.score);

  const result: RelatedPapers = { pmid, related };

  await cacheSet(cacheKey, result, CACHE_TTL);
  return result;
}
