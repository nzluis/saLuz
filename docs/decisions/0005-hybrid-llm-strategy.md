# 0005 — Hybrid LLM Strategy

- **Status:** Accepted
- **Date:** 2026-09-07

## Context

The consultation path answers health questions grounded in saLuz's
documented knowledge base (RAG). The constraints:

- **Privacy first** — symptom descriptions are sensitive; on-device
  processing is preferred.
- **Zero-budget** — cloud LLM usage must fit free tiers.
- **Offline-first** — the app must remain useful without connectivity.
- **Answer quality** — medical guidance must be accurate and cite sources.

Options for where generation happens:

| Option | Assessment |
|:-------|:-----------|
| Fully on-device LLM (e.g. Gemma 3n/4B quantized) | Maximum privacy and offline capability, but 3–5GB model download, slow time-to-first-token on mid-range devices (10s+), and weaker answer quality than larger cloud models. |
| Fully cloud LLM | Best quality per euro, but requires connectivity for every query and sends symptom text off-device. |
| Hybrid: on-device retrieval + cloud generation, local fallback | Embeddings and vector search stay local (ADR 0004); the cloud LLM (Groq free tier: Llama 3.3 70B, ~14k req/day) receives only retrieved context + question; when offline, the app answers from local retrieval without generative synthesis. |

## Decision

Adopt a **hybrid strategy**:

1. **Retrieval is always on-device** (embeddings + KNN via ADR 0004).
   Query text is embedded locally; raw symptom descriptions never leave the
   device as part of retrieval.
2. **Generation defaults to cloud** (Groq API, Llama 3.3 70B) with the
   retrieved chunks as grounding context, producing cited answers.
3. **Offline degradation is graceful**: without connectivity, the app
   returns the retrieved passages directly (with sources), clearly labeled
   as unsynthesized reference material.
4. A **confidence gate** in the orchestrator decides whether local
   retrieval is sufficient (high-similarity, well-covered topic) or cloud
   synthesis is warranted.

Every response carries the medical disclaimer (see `AGENTS.md`): saLuz is
educational, never diagnostic.

## Consequences

**Easier:**

- Fits the free tier: retrieval is free (local), generation is free up to
  Groq's daily quota — far above expected single-user volume.
- Privacy posture is strong: the only network payload is the question plus
  already-public monograph excerpts, and only when the user is online and
  synthesis is needed.
- Offline behavior degrades to "guided reading" instead of failing.
- No multi-GB model download; app size stays lean.

**Harder (accepted):**

- Answer quality offline is lower (retrieved excerpts vs. synthesized
  answer) — accepted and explicitly communicated in the UI.
- The orchestrator's confidence heuristic needs tuning and tests (Phase 7).
- Prompt engineering and citation formatting become core, test-covered
  code, not an afterthought.
