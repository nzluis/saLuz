# 0006 — Riverpod for State Management

- **Status:** Accepted
- **Date:** 2026-09-07

## Context

saLuz needs state management that handles: async data with loading/error
states everywhere (repository results), local caches shared across screens,
and providers that compose (e.g. consultation depends on content, sync
depends on connectivity). The developer is new to Flutter, so compile-time
safety and low boilerplate matter more than framework familiarity.

Alternatives considered:

| Option | Assessment |
|:-------|:-----------|
| `setState` / InheritedWidget | Too manual; rebuild storms and untestable wiring beyond a few screens. |
| Provider (classic) | Simple but relies on runtime type lookup; superseded by Riverpod from the same author. |
| BLoC | Excellent structure and devtools, but significant boilerplate (events, states, blocs per screen) and verbose for simple async reads; steeper initial ceremony for a solo developer. |
| GetX / MobX | Magical reactivity, weak compile-time guarantees, against the project's explicit-DI rule. |
| Riverpod 2.x | Compile-safe provider graph, `AsyncValue` models loading/error/data out of the box, testable by overriding providers, code generation removes boilerplate. |

## Decision

Use **Riverpod 2.x** (with `riverpod_generator` for code generation) as the
single state management and dependency injection mechanism.

Provider wiring follows `docs/conventions/architecture.md`: repositories and
services are exposed as providers; UI reads through `ref.watch`; tests
override providers with fakes — no service locators inside business logic.

## Consequences

**Easier:**

- `AsyncValue<T>` gives every screen the same loading/error/data triad the
  testing conventions already assume.
- Tests swap implementations with `ProviderScope(overrides: …)` — no extra
  mocking framework for DI.
- Code generation (`@riverpod`) keeps provider declarations terse and
  refactor-safe.
- One tool covers both DI and UI state; no split-brain between `get_it`
  registrations and widget state.

**Harder (accepted):**

- Riverpod's mental model (auto-dispose, family, codegen) has a learning
  curve; mitigated by documenting provider patterns in
  `docs/conventions/architecture.md` as they stabilize.
- Generated files add a `build_runner` step to the workflow (already
  standard in `AGENTS.md` commands).
