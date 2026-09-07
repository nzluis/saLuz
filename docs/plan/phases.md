# saLuz — Project Phases

> **Status:** Living document. Updated as phases complete or plans change.
> **Last updated:** 2026-09-07

This document is the canonical reference for the saLuz project roadmap. Each phase
lists atomic steps, deliverables, and estimated durations. Work always happens
inside the rules defined in [`AGENTS.md`](../../AGENTS.md) and
[`docs/conventions/`](../conventions/).

---

## Project Vision

saLuz is a mobile health education app with two connected paths:

1. **Teaching & Documentation** — Monographs on human physiology and
   pathophysiology, illustrated with animated graphic material (macro and
   microscopic level, e.g. gas exchange). Patients can learn how a body system
   works and what changes in a specific disease.
2. **Professional Consultation** — A specialized medical agent that uses the
   documented knowledge base to relate symptoms, signs, and user-provided
   indicators, guiding users toward the documented pathologies that match their
   criteria. It is **not** a diagnostic tool — it is a guide that helps users
   understand healthy systems and their pathological alterations.

Primary data source: **PubMed E-utilities API** (free, 36M+ biomedical papers).

---

## Phase Overview

| Phase | Name | Weeks | Status |
|:------|:-----|:------|:-------|
| 0 | Documentation & Rules | 1 (~2 days) | 🔵 In progress |
| 1 | Technical Foundation | 1–2 | ⚪ Pending |
| 2 | Backend — PubMed Client | 3 | ⚪ Pending |
| 3 | Content Pipeline | 4 | ⚪ Pending |
| 4 | App — Educational Content | 5–6 | ⚪ Pending |
| 5 | Medical Animations (Rive) | 7–8 | ⚪ Pending |
| 6 | On-Device RAG | 9–10 | ⚪ Pending |
| 7 | Hybrid Consultation Agent | 11–12 | ⚪ Pending |
| 8 | Offline-First & Sync | 13 | ⚪ Pending |
| 9 | Polish & Release Prep | 14 | ⚪ Pending |

---

## Phase 0: Documentation & Rules

*All definition work before writing code. No implementation happens here.*

| Step | Task | Deliverable | Duration |
|:-----|:-----|:------------|:---------|
| 0.1 | Repository setup + `.gitignore` (includes `/doc`) | Clean repo | 1h |
| 0.2 | `AGENTS.md` — vision, stack, golden rules | Entry doc | 2h |
| 0.3 | `docs/conventions/` — architecture, naming, testing, dart-style | Convention docs | 4h |
| 0.4 | ADRs 0001–0007 (full format) | Decision record | 4h |
| 0.5 | `docs/plan/phases.md` (this file) + `docs/knowledge/` placeholder | Indexes | 1h |

**Deliverable:** The rules of the game, written. Every later decision references these documents.

---

## Phase 1: Technical Foundation

*Flutter project bootstrap, informed by the conventions written in Phase 0.*

| Step | Task | Deliverable | Duration |
|:-----|:-----|:------------|:---------|
| 1.1 | Setup Flutter SDK 3.24+, Android Studio/Xcode, VS Code | Working environment | 2h |
| 1.2 | `flutter create saluz --org com.saluz --platforms android,ios` | Base project | 30min |
| 1.3 | `analysis_options.yaml` strict rules (per `docs/conventions/dart-style.md`) | Linting configured | 1h |
| 1.4 | CI/CD basic (GitHub Actions: analyze + test) | Green pipeline | 2h |
| 1.5 | Feature-First structure (`features/`, `core/`, `shared/`) | Folder scaffold | 2h |
| 1.6 | DI with `get_it` + `injectable` | DI configured | 3h |
| 1.7 | Riverpod 2.x with code generation | Providers base | 3h |
| 1.8 | GoRouter with typed routes | Router configured | 2h |
| 1.9 | Design System (Material 3: colors, typography, spacing) | Theme + base widgets | 4h |
| 1.10 | i18n (`flutter_localizations` + `intl`, es/en) | i18n configured | 2h |
| 1.11 | Error handling (`Result` types, error boundary) | Error base | 3h |
| 1.12 | Logging + storage (`shared_preferences`, secure storage) | Services | 2h |

**Checkpoint:** Compilable app boilerplate with navigation, strict linting, green CI.

---

## Phase 2: Backend — PubMed Client

*Node.js/Fastify backend exposing PubMed data to the app.*

| Step | Task | Deliverable | Duration |
|:-----|:-----|:------------|:---------|
| 2.1 | Setup Fastify + TypeScript + dotenv | Server base | 2h |
| 2.2 | Rate limiting (10 req/s, PubMed API key policy) | Rate limiter | 1h |
| 2.3 | `PubMedClient` with `esearch`, `efetch`, `esummary`, `elink` | Client working | 4h |
| 2.4 | TypeScript interfaces for PubMed responses | Types defined | 2h |
| 2.5 | Response cache (Upstash Redis or in-memory LRU) | Cache layer | 3h |
| 2.6 | `GET /api/search` — search papers by term | REST endpoint | 2h |
| 2.7 | `GET /api/paper/:id` — fetch paper by PMID | REST endpoint | 2h |
| 2.8 | `GET /api/related/:id` — related papers (elink) | REST endpoint | 2h |
| 2.9 | Unit tests (Jest + supertest, >80% coverage) | Test suite | 4h |
| 2.10 | OpenAPI documentation | Swagger spec | 2h |

**Checkpoint:** Documented, tested PubMed API.

---

## Phase 3: Content Pipeline

*From raw medical content to an embedded, searchable vector store.*

| Step | Task | Deliverable | Duration |
|:-----|:-----|:------------|:---------|
| 3.1 | Monograph JSON Schema (id, title, system, sections, sources) | Validated schema | 3h |
| 3.2 | Markdown parser for content extraction | Parser working | 3h |
| 3.3 | Chunking strategy (512 tokens, 50 overlap, paragraph-aware) | Chunker working | 4h |
| 3.4 | Embedding service (OpenAI `text-embedding-3-small`) | Embedding service | 2h |
| 3.5 | Batch embedding (lots of 100) | Batch processor | 3h |
| 3.6 | Turso (libSQL) setup with vector extension | DB configured | 2h |
| 3.7 | Vector schema (`vec0` table: id, content, embedding, metadata) | Table created | 2h |
| 3.8 | Ingestion pipeline: chunks + embeddings → Turso | Pipeline complete | 3h |
| 3.9 | `POST /api/content/ingest` — process and store a monograph | Ingestion API | 4h |

**Checkpoint:** First monograph indexed and searchable.

---

## Phase 4: App — Educational Content

*The teaching path: browse body systems, read monographs.*

| Step | Task | Deliverable | Duration |
|:-----|:-----|:------------|:---------|
| 4.1 | `features/content/` scaffold (data/domain/presentation) | Feature structure | 2h |
| 4.2 | Domain entities (`Monograph`, `Section`, `ContentChunk`, `BodySystem`) | Entities | 3h |
| 4.3 | `ContentRepository` port (interface) | Contract | 1h |
| 4.4 | Remote data source (`ContentApi`) | API client | 3h |
| 4.5 | Local data source (Drift/SQLite cache) | Local storage | 3h |
| 4.6 | `ContentRepositoryImpl` with cache strategy | Repository working | 4h |
| 4.7 | Body systems list screen (grid) | UI working | 4h |
| 4.8 | Monograph detail screen (structured sections) | UI working | 4h |
| 4.9 | Section navigation (scroll controller + anchors) | Smooth UX | 3h |

**Checkpoint:** Working educational navigation flow.

---

## Phase 5: Medical Animations (Rive)

*Interactive animated content for physiological processes.*

| Step | Task | Deliverable | Duration |
|:-----|:-----|:------------|:---------|
| 5.1 | Setup `rive` package + asset pipeline | Runtime configured | 2h |
| 5.2 | Rive workspace structure for saLuz | Workspace ready | 1h |
| 5.3 | "Gas Exchange" animation (alveoli, O2/CO2 flow) | `.riv` file | 8h |
| 5.4 | State machine (play/pause, macro/micro zoom, highlight) | State machine | 4h |
| 5.5 | Reusable `RiveWidget` wrapper with controller | Component | 4h |
| 5.6 | Data binding (state machine ↔ app state) | Interactivity | 3h |
| 5.7 | "Cardiac Cycle" animation | `.riv` file | 8h |
| 5.8 | Asset optimization (compression, lazy loading) | Optimized assets | 2h |
| 5.9 | Static SVG fallback for low-end devices | Fallback | 3h |

**Checkpoint:** 2 animations integrated and functional.

---

## Phase 6: On-Device RAG

*Semantic search running fully on the device.*

| Step | Task | Deliverable | Duration |
|:-----|:-----|:------------|:---------|
| 6.1 | Setup `sqlite_vector` + extension load | Vector DB local | 3h |
| 6.2 | Local schema (`vec_documents`: id, content, embedding, metadata) | Schema created | 2h |
| 6.3 | On-device embedding service (MediaPipe Text Embedder) | Embedding service | 6h |
| 6.4 | Sync pipeline (download monographs → chunk → embed → store) | Sync service | 6h |
| 6.5 | Semantic search (KNN query) | Search working | 4h |
| 6.6 | Metadata filters (by system, content type) | Filters working | 3h |
| 6.7 | Query result cache (LRU) | Cache layer | 2h |
| 6.8 | Search state UI ("searching locally…") | UX feedback | 2h |
| 6.9 | Performance benchmarks (1000 docs, query <100ms) | Benchmarks | 3h |

**Checkpoint:** Offline RAG working end-to-end.

---

## Phase 7: Hybrid Consultation Agent

*The consultation path: local-first, cloud for complex queries.*

| Step | Task | Deliverable | Duration |
|:-----|:-----|:------------|:---------|
| 7.1 | `features/consultation/` scaffold | Feature structure | 2h |
| 7.2 | Domain entities (`Query`, `Response`, `Citation`, `Confidence`) | Entities | 3h |
| 7.3 | `LocalConsultationService` (uses on-device RAG) | Local service | 4h |
| 7.4 | Groq API client (Llama 3.3 70B) | API client | 3h |
| 7.5 | Prompt engineering (medical system prompt + RAG context) | Optimized prompts | 4h |
| 7.6 | Hybrid orchestrator (local vs cloud by confidence) | Orchestrator | 4h |
| 7.7 | Citation system (extract and format sources) | Citations | 3h |
| 7.8 | Consultation chat UI with history | UI working | 6h |
| 7.9 | Consultation history persistence | History working | 3h |

**Checkpoint:** Working consultation agent.

---

## Phase 8: Offline-First & Sync

*Full functionality without connectivity.*

| Step | Task | Deliverable | Duration |
|:-----|:-----|:------------|:---------|
| 8.1 | Network detection (`connectivity_plus`) | Network service | 2h |
| 8.2 | Sync strategy (pending operations queue) | Sync manager | 4h |
| 8.3 | Background monograph download | Download service | 4h |
| 8.4 | Incremental embedding sync | Embedding sync | 4h |
| 8.5 | Conflict resolution (last-write-wins for history) | Conflict resolver | 3h |
| 8.6 | Offline state UI (banner + sync indicators) | Offline UX | 3h |

**Checkpoint:** App 100% functional offline.

---

## Phase 9: Polish & Release Prep

*Performance, accessibility, and release readiness.*

| Step | Task | Deliverable | Duration |
|:-----|:-----|:------------|:---------|
| 9.1 | Performance optimization (DevTools, reduce rebuilds) | Optimized app | 4h |
| 9.2 | Asset optimization (images, lazy animation loading) | Optimized assets | 3h |
| 9.3 | Accessibility (semantic labels, screen reader) | a11y compliant | 4h |
| 9.4 | Integration + golden tests | Test suite | 6h |
| 9.5 | Code documentation (dartdoc for public APIs) | Generated docs | 3h |
| 9.6 | Release builds (signed APK/AAB + IPA) | Release artifacts | 4h |

**Checkpoint:** Release candidate available.

---

## Dependency Graph

```
Phase 0 (Docs) ──► Phase 1 (Foundation) ──► Phase 2 (Backend) ──► Phase 3 (Pipeline)
                                                  │
Phase 5 (Animations) ◄── Phase 4 (Content) ◄──────┘
                          │
                          ▼
                   Phase 6 (RAG Local) ──► Phase 7 (Agent) ──► Phase 8 (Offline) ──► Phase 9 (Release)
```

## Known Risks

| Risk | Likelihood | Impact | Mitigation |
|:-----|:-----------|:-------|:-----------|
| Rive animation creation takes longer | High | 1–2 week delay | Start from Rive Community anatomy assets |
| MediaPipe embedder underperforms in Spanish | Medium | Degraded local RAG | Fall back to cloud embeddings or multilingual model |
| App size exceeds 100MB | Medium | Slow downloads | Lazy-load monographs, compress assets |
| Groq rate limits too tight | Low | Failed consultations | Aggressive caching, retry queue |
| `sqlite-vec` pre-v1 breaking changes | Medium | DB refactoring | Wrapper abstraction, planned migrations |
