# 0002 — Feature-First Architecture

- **Status:** Accepted
- **Date:** 2026-09-07

## Context

saLuz has clearly separated business capabilities: educational content,
consultation agent, sync/offline infrastructure, with more planned
(favorites, history, settings). The project will grow over months with
long gaps between sessions — returning to the codebase must be cheap.

Alternatives considered:

| Option | Assessment |
|:-------|:-----------|
| Layer-first (`lib/domain/`, `lib/data/`, `lib/presentation/`) | Works for very small apps, but at ~10 features each layer folder accumulates dozens of unrelated files; nothing ties a feature's pieces together except naming discipline. |
| Full package-per-layer monorepo (FFCA-style) | Compiler-enforced boundaries and per-feature packages, but heavy tooling (workspaces, per-package pubspecs) for a single-developer project; overhead outweighs the benefit. |
| MVVM without explicit layering | Too permissive; business logic drifts into widgets, which is exactly what the RAG and sync features cannot afford. |

## Decision

Adopt **Feature-First organization** with Clean Architecture layers inside
each feature:

```
lib/features/<feature>/{data, domain, presentation}
```

with the dependency rule `presentation → domain ← data`, enforced by the
litmus check documented in `docs/conventions/architecture.md`:

```bash
grep -rn "package:flutter\|package:dio\|package:drift" lib/features/*/domain/
# expected: no output
```

## Consequences

**Easier:**

- Deleting or freezing a feature means deleting one folder.
- Each feature's tests mirror the same structure; onboarding back into the
  project after a break starts from the feature folder, not a global map.
- Domain purity is mechanically checkable with a single grep.
- Layer boilerplate appears only where a feature earns it — small features
  can stay thin without breaking the rule.

**Harder (accepted):**

- Boundaries are enforced by review and the grep litmus, not by the
  compiler (no package-level isolation).
- Cross-feature sharing must go through `shared/` or domain entities;
  the temptation to reach into a sibling feature's `data/` requires
  discipline.
