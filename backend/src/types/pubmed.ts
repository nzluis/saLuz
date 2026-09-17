export interface ESearchResponse {
  esearchresult: {
    count: string;
    retmax: string;
    retstart: string;
    idlist: string[];
    querykey: string;
    webenv: string;
  };
}

export interface ESummaryPaper {
  uid: string;
  pubdate: string;
  authorstring: string;
  title: string;
  source: string;
  fulljournalname: string;
  elocationid: string;
  doistring: string | null;
  articlesinfluencedbycount: string;
  availablefromurl: string;
  locationlabel: string;
  docsum: string;
}

export interface ESummaryResponse {
  result: {
    uids: string[];
  } & Record<string, ESummaryPaper>;
}

export interface PubMedArticle {
  pmid: string;
  title: string;
  authors: string[];
  journal: string;
  pubDate: string;
  doi: string | null;
  abstract: string;
}

export interface EFetchRequest {
  webenv: string;
  queryKey: string;
  retstart: number;
  retmax: number;
}

export interface ELinkResponse {
  linksets: Array<{
    linksetdbs?: Array<{
      linkname: string;
      links: Array<{
        score: string;
        uid: string;
      }>;
    }>;
  }>;
}

export interface SearchResult {
  count: number;
  papers: PubMedArticle[];
  webenv: string;
  queryKey: string;
}

export interface PaperDetail {
  pmid: string;
  title: string;
  authors: string[];
  journal: string;
  pubDate: string;
  doi: string | null;
  abstract: string;
}

export interface RelatedPapers {
  pmid: string;
  related: Array<{
    pmid: string;
    score: number;
  }>;
}
