# 0001 — Flutter as Mobile Framework

- **Status:** Accepted
- **Date:** 2026-09-07

## Context

saLuz targets both Android and iOS from day one. Its two distinguishing
technical demands are:

1. **Complex, fluid medical animations** (e.g. gas exchange at the alveolar
   level, cardiac cycle) that must hold 60fps on mid-range devices.
2. **On-device RAG** (embedding generation + vector search) with acceptable
   performance and full offline capability.

Additional forces:

- Single-developer project with a web background (TypeScript/React), no
  native mobile experience, and an explicit goal of learning a new,
  well-established technology.
- No time-to-market pressure; learning curve is acceptable.
- Zero-budget constraint: everything must run on free tiers.

Alternatives considered:

| Option | Assessment |
|:-------|:-----------|
| React Native + Expo | Minimal learning curve (existing React knowledge), but the bridge architecture still drops frames on complex animations on mid-range Android; larger binary; learning goal unmet. |
| Kotlin Multiplatform | Best native fidelity, but Compose Multiplatform on iOS is still maturing (gesture and animation gaps); risks doubling UI work for native feel; smaller ecosystem. |
| Go (Fyne/Gio) | Tooling too immature for production mobile apps with rich animation and RAG requirements. |
| Rust (UniFFI core + native shells) | Maximum performance for the RAG core, but requires maintaining three codebases (Rust + SwiftUI + Compose) with a complex cross-compilation toolchain; no mature Rust mobile UI layer. |

## Decision

Use **Flutter** (Dart) as the single mobile framework, with the Impeller
rendering engine.

## Consequences

**Easier:**

- One codebase for both platforms, including UI — fastest path to feature
  parity.
- Impeller delivers consistent 60fps rendering on mid-range hardware, which
  the medical animations demand.
- Rive and Lottie have first-class Flutter support; the animation pipeline
  (ADR 0003) integrates natively.
- SQLite vector extensions (`sqlite_vector`) are available as Flutter
  packages for on-device RAG (ADR 0004).
- Dart is a modern, null-safe, strongly typed language — a genuinely new
  skill for the developer without being alien to a TypeScript background.

**Harder (accepted):**

- Dart's ecosystem is smaller than JavaScript's; some niche packages will
  need to be written rather than installed.
- App binary is larger than native (~10–15MB baseline) — mitigated by
  lazy-loading monograph content rather than bundling it.
- Hiring/community support pool is smaller than React's — irrelevant for a
  single-developer project.
