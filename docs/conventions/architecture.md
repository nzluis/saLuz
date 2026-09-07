# Architecture Conventions

How saLuz code is structured. These rules are enforced by review and by the
litmus checks described below.

---

## Feature-First with Clean Layers

The codebase is organized by **feature**, not by layer. Each feature is a
vertical slice containing its own three layers:

```
lib/features/content/
├── data/
│   ├── datasources/       # Remote (API) and local (Drift) data sources
│   ├── dto/               # Data transfer objects (API/DB shape)
│   └── repositories/      # Repository implementations
├── domain/
│   ├── entities/          # Business objects (pure Dart)
│   ├── repositories/      # Repository contracts (abstract classes)
│   └── failures.dart      # Typed failures for this feature
└── presentation/
    ├── providers/         # Riverpod providers/notifiers
    ├── screens/           # Full-screen widgets
    └── widgets/           # Feature-specific widgets
```

Cross-cutting code lives outside `features/`:

| Folder | Contents |
|:-------|:---------|
| `lib/app/` | Bootstrap, app shell, lifecycle, router wiring |
| `lib/core/` | Network, storage, environment, logging — infrastructure only |
| `lib/design_system/` | Theme, colors, typography, reusable base widgets |
| `lib/shared/` | Feature-agnostic utilities (extensions, helpers) |

**Rule:** `shared/` and `core/` must never import from `features/`. Features
must never import from each other's `data/` or `presentation/`. Cross-feature
communication happens through domain entities or the app-level router.

---

## The Dependency Rule

Dependencies point inward. Always.

```
presentation ──depends on──► domain ◄──depends on── data
```

- `presentation/` may import from `domain/` of the same feature.
- `data/` may import from `domain/` of the same feature.
- `domain/` imports **nothing** from the app — only pure Dart and small
  pure packages (e.g. `equatable`).

### Litmus test

A domain layer that follows the rule produces zero hits here:

```bash
grep -rn "package:flutter\|package:dio\|package:drift\|package:sqlite" lib/features/*/domain/
```

Expected output: nothing. If a domain file imports Flutter, an HTTP client, or
a database library, the boundary is broken — fix it before committing.

---

## Repository Pattern

Every external data source is hidden behind a contract defined in `domain/`.

```dart
// domain/repositories/content_repository.dart
abstract interface class ContentRepository {
  Future<Result<List<Monograph>>> getMonographs({required BodySystem system});
  Future<Result<Monograph>> getMonograph({required MonographId id});
}

// data/repositories/content_repository_impl.dart
final class ContentRepositoryImpl implements ContentRepository {
  ContentRepositoryImpl({required ContentApi api, required ContentDao dao})
      : _api = api,
        _dao = dao;

  final ContentApi _api;
  final ContentDao _dao;

  @override
  Future<Result<List<Monograph>>> getMonographs({required BodySystem system}) {
    // Cache strategy lives here, not in presentation.
  }
}
```

Rules:

- **Ports speak domain types.** The contract returns `Monograph`, never
  `MonographDto`. Mapping DTO → entity happens in the implementation.
- **Adapters absorb vendors.** `ContentApi` knows about HTTP and JSON.
  `ContentRepositoryImpl` does not.
- **Decorators for cross-cutting behavior.** Caching is a decorator
  (`CachedContentRepository`) wrapping the real implementation, configured
  in one place (DI registration), never scattered through call sites.

---

## Error Handling: Result Types

Failures are values, not exceptions, at layer boundaries.

```dart
// shared/result.dart
sealed class Result<T> {
  const Result();
}

final class Success<T> extends Result<T> {
  const Success(this.value);
  final T value;
}

final class Failure<T> extends Result<T> {
  const Failure(this.error);
  final AppFailure error;
}

sealed class AppFailure {
  const AppFailure();
}

final class NetworkFailure extends AppFailure { /* … */ }
final class NotFoundFailure extends AppFailure { /* … */ }
final class SyncFailure extends AppFailure { /* … */ }
```

Rules:

- Repositories return `Result<T>`. They never throw across the boundary.
- Providers fold `Result` into UI state (`AsyncValue`, sealed state classes).
- **Fail fast:** parsing a `PubMedId` from invalid input throws immediately in
  the value object's factory — invalid states are unrepresentable below the
  parsing boundary.
- Exceptions are reserved for programming errors and truly unrecoverable
  states (asserts, unreachable code).

---

## Dependency Injection

Constructor injection everywhere. No service locators inside business logic.

```dart
// core/di/providers.dart
final contentApiProvider = Provider<ContentApi>(
  (ref) => ContentApi(ref.watch(dioProvider)),
);

final contentRepositoryProvider = Provider<ContentRepository>(
  (ref) => CachedContentRepository(
    ContentRepositoryImpl(
      api: ref.watch(contentApiProvider),
      dao: ref.watch(contentDaoProvider),
    ),
  ),
);
```

Rules:

- Dependencies are declared in constructors, `final`, and injected.
- Singletons live in Riverpod providers — never in global variables or
  static fields holding mutable state.
- A class receives **what it needs, already built**. It never reaches into
  a container itself (`ref.watch` belongs in providers and UI only).

---

## Value Objects

Simple wrapped types with validation at construction and private constructors.

```dart
final class PubMedId extends Equatable {
  const PubMedId._(this.value);

  factory PubMedId.parse(String raw) {
    final normalized = raw.trim();
    if (!RegExp(r'^\d{1,8}$').hasMatch(normalized)) {
      throw ArgumentError.value(raw, 'raw', 'Invalid PubMed ID');
    }
    return PubMedId._(normalized);
  }

  final String value;

  @override
  List<Object?> get props => [value];
}
```

Rules:

- Immutable: `final` fields, `const` private constructor.
- Validated: the only way in is a factory (`parse`, `fromJson` via DTOs).
- Compared by value: extend `Equatable` or override `==`.
- Prefer a value object over a bare `String`/`int` whenever the value has
  meaning (`PubMedId`, `EmbeddingVector`, `MonographId`).

---

## Immutability

- State objects are immutable; updates produce new instances (`copyWith`,
  generated by `freezed` where boilerplate grows).
- Collections exposed publicly are unmodifiable views.
- Widgets are `const` wherever possible.

---

## What Does NOT Belong Here

- Feature flags per environment — those live in `core/env`.
- Business rules in widgets — move them to a provider or the domain layer.
- Comments explaining *what* code does — rename the code instead
  (see [naming.md](naming.md)).
