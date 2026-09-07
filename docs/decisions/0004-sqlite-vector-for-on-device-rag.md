# 0004 — SQLite Vector for On-Device RAG

- **Status:** Accepted
- **Date:** 2026-09-07

## Context

saLuz's consultation feature retrieves relevant monograph chunks by semantic
similarity (RAG). The project rules state **privacy first: medical data
defaults to on-device processing**, and Phase 8 requires full offline
functionality. We therefore need vector storage and KNN search running
locally on Android and iOS.

The expected local corpus is small: ~10–50 monographs chunked into a few
thousand passages with 384-dimensional embeddings (well under 1M vectors).

Alternatives considered:

| Option | Assessment |
|:-------|:-----------|
| In-memory brute force | Fine at 1k vectors, but forces loading all embeddings on startup; memory grows with corpus; no persistence story. |
| ObjectBox (with vector search) | Capable and fast, but adds a second database alongside the relational store; Dart vector support is younger than SQLite's ecosystem. |
| Isar | No native vector search; would require brute-force in Dart. Also its maintenance status is uncertain. |
| Remote vector DB only (Turso cloud) | Breaks offline-first and privacy-first for query embeddings. |
| SQLite + `sqlite_vector` extension | Vector search inside the same SQLite file used for everything else (Drift); published Flutter package with Android/iOS support; SIMD-optimized distance functions; ~30MB memory footprint; zero new infrastructure. |

## Decision

Use **SQLite with the `sqlite_vector` extension** (via the `sqlite_vector`
pub package) as the on-device vector store, integrated with the same Drift
database used for relational data (ADR 0007).

Embeddings are generated on-device (MediaPipe Text Embedder) and at ingest
time in the backend pipeline; the local store keeps both.

## Consequences

**Easier:**

- One database file holds relational data, metadata, and vectors — one
  backup, one migration path, one sync unit.
- KNN queries run in C inside SQLite, not in Dart; no manual index
  management at our corpus size (thousands of vectors → sub-100ms queries
  per the Phase 6 benchmark gate).
- Stays within the SQLite ecosystem the team already uses for Drift.
- Fully offline and private: embeddings never leave the device.

**Harder (accepted):**

- `sqlite-vec` is pre-v1 and warns of breaking changes — mitigated by
  hiding all vector SQL behind a `VectorStore` port in the domain layer, so
  a future swap (or a major version bump) touches one adapter.
- Very large corpora (>100k vectors) would need re-evaluation; at saLuz's
  scale this is not a near-term concern.
