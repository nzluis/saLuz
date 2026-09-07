# Architecture Decision Records

ADRs document why significant technical decisions were made. They are
append-only: a wrong decision is superseded by a new ADR, never rewritten.

---

## Format

Each ADR is a file `NNNN-title-in-kebab-case.md` numbered sequentially
(first merged wins the number). Template:

```markdown
# NNNN — Title

- **Status:** Proposed | Accepted | Superseded by [NNNN](NNNN-….md)
- **Date:** YYYY-MM-DD

## Context

The forces at play: requirements, constraints, alternatives considered.

## Decision

What we decided, stated plainly.

## Consequences

What becomes easier, what becomes harder, what we explicitly accept.
```

Keep ADRs short. The decision and its reasoning matter, not the prose.

---

## Index

| # | Title | Status | Date |
|:--|:------|:-------|:-----|
| [0001](0001-flutter-as-mobile-framework.md) | Flutter as mobile framework | Accepted | 2026-09-07 |
| [0002](0002-feature-first-architecture.md) | Feature-First architecture | Accepted | 2026-09-07 |
| [0003](0003-rive-for-medical-animations.md) | Rive for medical animations | Accepted | 2026-09-07 |
| [0004](0004-sqlite-vector-for-on-device-rag.md) | SQLite vector for on-device RAG | Accepted | 2026-09-07 |
| [0005](0005-hybrid-llm-strategy.md) | Hybrid LLM strategy | Accepted | 2026-09-07 |
| [0006](0006-riverpod-for-state-management.md) | Riverpod for state management | Accepted | 2026-09-07 |
| [0007](0007-drift-for-local-database.md) | Drift for local database | Accepted | 2026-09-07 |

Next available number: **0008**
