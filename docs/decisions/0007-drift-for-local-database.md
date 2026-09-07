# 0007 — Drift for Local Database

- **Status:** Accepted
- **Date:** 2026-09-07

## Context

saLuz persists monographs, chunks, embeddings metadata, consultation
history, and sync state locally. The database must:

- Speak real SQL (vector extension integration per ADR 0004 runs on SQLite).
- Support migrations as the schema evolves across phases.
- Be type-safe at the Dart boundary.
- Work fully offline (trivially true for SQLite) and on both platforms.

Alternatives considered:

| Option | Assessment |
|:-------|:-----------|
| Raw `sqflite` | Full SQL control but untyped rows and hand-written mapping everywhere; error-prone as schema grows. |
| Floor | Type-safe-ish, but less active and weaker migration/tooling story than Drift. |
| Isar | NoSQL, pleasant API, but no SQLite underneath — blocks the `sqlite_vector` path from ADR 0004; maintenance uncertainty. |
| Hive | Key-value only; wrong shape for relational monograph/chunk/history data. |
| Drift | Mature, actively maintained SQLite ORM for Dart: type-safe queries, generated DAOs, first-class migration tooling, and direct access to the underlying database for loading extensions like `sqlite_vector`. |

## Decision

Use **Drift** as the local relational database, on top of `sqlite3` with
the `sqlite_vector` extension loaded at open time.

Schema versioning uses Drift migrations; every schema change ships with a
migration and a migration test.

## Consequences

**Easier:**

- Entities and queries are checked at compile time; schema drift between
  Dart and SQL surfaces at build, not at runtime.
- The same file hosts relational tables and the `vec0` virtual table
  (ADR 0004) — one open, one backup, one sync artifact.
- Migration tooling (`drift_dev` schema dumps + tests) makes schema
  evolution safe across app releases.
- Streaming queries (`watch()`) integrate naturally with Riverpod for
  reactive lists (history, downloads).

**Harder (accepted):**

- Drift adds codegen (`build_runner`) and a learning curve for its query
  API; acceptable within the project's learning goals.
- Custom SQL (vector KNN) is written as raw SQL inside the vector store
  adapter — deliberately isolated behind the `VectorStore` port so Drift
  specifics never leak into the domain.
