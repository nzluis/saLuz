# Knowledge Base

Deep-dive guides written as the project needs them. Unlike conventions
(how we code) and ADRs (why we decided), this section captures **how things
work** — integration details, gotchas, and operational runbooks.

Each guide is added when the knowledge is earned, not before. Planned areas:

## Planned Guides

| Area | Expected content | Added in phase |
|:-----|:-----------------|:---------------|
| Flutter | Project setup quirks, platform channel notes, Impeller flags | Phase 1 |
| PubMed | E-utilities usage patterns: MeSH queries, rate-limit handling, pagination, batch fetching | Phase 2 |
| Content pipeline | Chunking heuristics, embedding batch costs, Turso operational notes | Phase 3 |
| Rive | State machine authoring workflow, asset optimization, Flutter runtime patterns | Phase 5 |
| On-device AI | MediaPipe embedder setup, model pinning (SHA-256), memory benchmarks | Phase 6 |
| LLM | Prompt versions and evaluation notes, Groq operational limits | Phase 7 |
| Sync | Conflict-resolution behavior, background download constraints per platform | Phase 8 |

## Writing Guide

- One topic per file: `pubmed/e-utilities-rate-limits.md`.
- Link from this index when adding a file.
- Operational knowledge (how to rotate a key, how to re-run an ingest)
  belongs here, not in ADRs.
