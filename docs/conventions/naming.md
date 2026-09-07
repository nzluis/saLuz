# Naming Conventions

Names are the primary documentation of this codebase. A name that needs a
comment to be understood is a bad name.

---

## The Golden Rule

> If you need a comment to explain **what** something does, rename it.
> Comments answer **why**, never **what**.

```dart
// ❌ Bad
// Checks if the user has downloaded the monograph
final d = await dao.exists(id);

// ✅ Good
final monographIsCached = await dao.monographExists(id);
```

Rationale behind a non-obvious decision belongs in a comment (`// why:`),
a commit message, or an ADR — not beside the code.

---

## Files and Folders

| Element | Convention | Examples |
|:--------|:-----------|:---------|
| Files | `snake_case.dart` | `content_repository.dart`, `gas_exchange_screen.dart` |
| Folders | `snake_case` | `body_systems/`, `data_sources/` |
| Test files | mirror source + `_test.dart` | `content_repository_test.dart` |
| Generated files | `*.g.dart`, `*.freezed.dart` | never hand-edit |
| Barrel files | avoid, except feature public API | `content.dart` exporting the feature's public surface |

One public class per file. File name matches the class it contains
(`ContentRepository` → `content_repository.dart`).

---

## Classes

| Kind | Convention | Examples |
|:-----|:-----------|:---------|
| Entities | Noun, no suffix | `Monograph`, `BodySystem`, `Citation` |
| Repository contracts | `XRepository` | `ContentRepository`, `ConsultationRepository` |
| Repository implementations | prefix describes mechanism | `CachedContentRepository`, `DriftContentRepository` |
| Data sources | `XApi` (remote), `XDao` (local) | `PubMedApi`, `MonographDao` |
| DTOs | `XDto` | `MonographDto`, `PubMedArticleDto` |
| Value objects | descriptive noun | `PubMedId`, `EmbeddingVector`, `ConfidenceScore` |
| Failures | `XFailure` | `NetworkFailure`, `MonographNotFoundFailure` |
| Riverpod providers (classes) | `XNotifier` | `ContentListNotifier`, `ConsultationNotifier` |
| Widgets: screens | `XScreen` | `MonographDetailScreen` |
| Widgets: components | descriptive noun | `BodySystemCard`, `GasExchangeAnimation` |
| Enums / sealed classes | singular noun | `BodySystem`, `SyncStatus` |

**No Hungarian notation.** No `IMonograph` for interfaces, no `mMonograph`
for members, no `strName`. Dart has types; names carry meaning.

---

## Members

| Kind | Convention | Examples |
|:-----|:-----------|:---------|
| Methods | verb or verb phrase, `camelCase` | `fetchMonograph()`, `searchSimilar()`, `markAsSynced()` |
| Getters | noun, `camelCase` | `isCached`, `monographCount` |
| Booleans | `is`/`has`/`can`/`should` prefix | `isOnline`, `hasEmbeddings`, `canRetry` |
| Variables | descriptive noun, `camelCase` | `monographList`, `cachedResults` — never `data`, `tmp`, `x` |
| Private members | `_leadingUnderscore` | `_api`, `_maxRetries` |
| Constants | `lowerCamelCase`, `const` | `defaultPageSize`, `maxRetries` |
| Static constants | `lowerCamelCase` | `ContentApi.baseUrl` is `baseUrl` inside the class |

**Type parameters:** single uppercase letter for simple cases (`T`, `K`, `V`),
descriptive `PascalCase` when constrained (`T extends Entity` → `TEntity` only
if it clarifies).

---

## Providers (Riverpod)

| Kind | Convention | Examples |
|:-----|:-----------|:---------|
| Provider variables | `xProvider`, `camelCase` | `contentRepositoryProvider` |
| Notifier providers | `xNotifierProvider` | `contentListNotifierProvider` |

The provider name says what it **provides**, not how it works:
`contentRepositoryProvider`, not `contentRepositorySingletonProvider`.

---

## Functions vs Methods

- Top-level functions only in `shared/` utilities, and only when no class
  owns the concept (`formatBytes`, `chunkText`).
- Everything that touches instance state or collaborators is a method.
- A method that never touches `$this` should be `static` — or reconsider
  whether it belongs on the class at all.

---

## Async Naming

- `Future`-returning methods use the plain verb: `fetchMonograph()`.
- `Stream`-returning methods use `watch`/`observe`: `watchMonographs()`.
- Never suffix with `Async` — the return type already says it.

---

## Tests

| Element | Convention | Examples |
|:--------|:-----------|:---------|
| Test classes/groups | mirror the unit under test | `group('ContentRepositoryImpl', …)` |
| Test names | sentence describing behavior | `'returns cached monographs when offline'` |
| Mocks | `MockX` via mocktail | `MockContentApi()` |

Test names read as specifications: *"ContentRepositoryImpl returns cached
monographs when offline"* — not `test1` or `testGetMonographs`.

---

## Abbreviations

Allowed when universally understood in context: `Api`, `Dao`, `Dto`, `Id`,
`Url`, `Ui`. Two-letter acronyms are all-caps (`UI` inside class names only
when standing alone, e.g. `UiState`); longer ones are `PascalCase`
(`Http`, not `HTTP`, in class names).

Domain abbreviations are fine when the domain uses them: `PubMed`, `MeSH`
(in identifiers: `meshTerms`).

---

## Language

All code, comments, commit messages, and documentation are written in
**English**. User-facing strings live in the i18n layer (`app_en.arb`,
`app_es.arb`), never hardcoded.
