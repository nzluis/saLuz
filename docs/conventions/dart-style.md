# Dart Style Conventions

Dart-specific style rules for saLuz. Enforced by `analysis_options.yaml`
and code review.

---

## Static Analysis

The project uses strict analysis. `analysis_options.yaml` at the repo root:

```yaml
include: package:flutter_lints/flutter.yaml

analyzer:
  language:
    strict-casts: true
    strict-inference: true
    strict-raw-types: true
  errors:
    # Elevated to errors — these block a merge
    dead_code: error
    unused_import: error
    unused_local_variable: error
    avoid_unnecessary_containers: error

linter:
  rules:
    # Immutability & correctness
    - prefer_final_fields
    - prefer_final_locals
    - prefer_const_constructors
    - prefer_const_declarations
    - avoid_mutable_fields_in_final_classes

    # Type safety
    - avoid_dynamic_calls
    - always_declare_return_types
    - type_annotate_public_apis

    # Async hygiene
    - discarded_futures
    - unawaited_futures

    # Style
    - prefer_single_quotes
    - sort_pub_dependencies
    - directives_ordering
```

`flutter analyze` must report **zero issues** before any merge. There are no
baselines and no suppressed files — code meets the bar, or it doesn't merge.

---

## Immutability

- **Everything is `final` by default** — fields, locals, parameters.
  Introduce `var` only when mutation is genuinely required.
- **Classes are `final` by default.** Open a class for extension only with
  a deliberate reason (documented in the class doc).
- **`const` wherever possible:** constructors, widget trees, collections.
- Public collections are unmodifiable:

```dart
final class Monograph {
  const Monograph({required this.sections});

  final List<Section> sections; // passed as List.unmodifiable at construction
}
```

- State classes are immutable; updates produce new instances via `copyWith`
  (hand-written for small classes, `freezed` when boilerplate grows).

---

## Type Safety

- **Never `dynamic`.** If a JSON payload is untyped, decode it into a DTO
  at the boundary and work with the DTO from there.
- Return types are always declared, including `void`.
- Public APIs are fully typed — inference is for local variables only.
- `sealed` classes for closed hierarchies (Result, failures, UI states) —
  exhaustive `switch` expressions are the compiler-checked benefit.

---

## Null Safety

- Non-nullable by default; `?` only when absence is a real domain state.
- Never `!` (force unwrap) in production code. If you "know" it's non-null,
  prove it with a local check or restructure.
- Prefer early returns over nested null checks:

```dart
Monograph? findCached(MonographId id) {
  final dto = _cache[id];
  if (dto == null) return null;
  return dto.toEntity();
}
```

---

## Async

- Every `Future` is awaited, returned, or explicitly handled
  (`unawaited(...)` from `dart:async` with a comment saying why).
- No `async` functions that return without an `await` — drop the keyword.
- `Stream` subscriptions are always cancelled (Riverpod handles this for
  providers; manual subscriptions need `ref.onDispose` or `dispose`).

---

## Imports

Ordered, in groups separated by blank lines:

```dart
import 'dart:async';
import 'dart:collection';

import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/result.dart';
import '../../domain/entities/monograph.dart';
```

1. `dart:` libraries
2. `package:` third-party
3. Relative imports

Never use absolute `package:saluz/...` imports inside `lib/` — relative
imports keep features movable.

---

## Constructors

- Constructor tear-offs and promotion: `const Monograph({required this.id});`
- Named constructors for alternate creation paths: `Monograph.empty()`,
  `PubMedId.parse(raw)`.
- Factory constructors when validation or caching is involved (see value
  objects in [architecture.md](architecture.md)).
- No business logic in constructors — assignment only.

---

## Widgets

- `const` constructors with `super.key` — always.
- One widget per file; small private widgets (`_SectionHeader`) may share a
  file with their only consumer.
- Build methods stay flat: extract widgets instead of nesting beyond ~3
  levels.
- No logic in `build` beyond mapping state to UI. Fetching, transforming,
  and deciding belong in providers or the domain layer.

---

## Formatting

- `dart format` with default settings (80 columns). Run on save; CI verifies.
- Trailing commas on multi-line argument/parameter lists — they produce
  cleaner diffs and better auto-formatting.

---

## Code Generation

Generated files (`*.g.dart`, `*.freezed.dart`) are:

- Never hand-edited.
- Regenerated with `dart run build_runner build --delete-conflicting-outputs`.
- Committed to the repository (reproducible builds without codegen at
  build time).

---

## Documentation Comments

- `///` doc comments on **public APIs of domain and shared layers** —
  contracts, value objects, repositories.
- Not required on: overrides, private members, self-explanatory widgets.
- Doc comments state the contract (inputs, outputs, errors), not the
  implementation. Implementation whys go in inline `// why:` comments,
  sparingly.
