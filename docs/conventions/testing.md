# Testing Conventions

Tests are first-class citizens. A feature is not done until its tests are
written and green.

---

## Test Pyramid

```
        ╱ Integration ╲      few, critical flows only
       ╱   Widget      ╲     key screens and visual states
      ╱     Unit        ╲    the bulk — domain, data, providers
     ╱────────────────────╲
```

| Level | Location | Tooling | Target |
|:------|:---------|:--------|:-------|
| Unit | `test/features/<f>/domain/`, `test/features/<f>/data/` | `flutter_test` + `mocktail` | 90% of domain/data logic |
| Widget | `test/features/<f>/presentation/` | `flutter_test` | 80% of screens |
| Golden | `test/features/<f>/presentation/goldens/` | `golden_toolkit` | key visual states |
| Integration | `integration_test/` | `integration_test` | critical user flows only |

`test/` mirrors `lib/` exactly. A test for
`lib/features/content/data/repositories/content_repository_impl.dart` lives at
`test/features/content/data/repositories/content_repository_impl_test.dart`.

---

## Unit Tests

- Test **one unit** (class or function) in isolation.
- Mock every collaborator with `mocktail`. Only interfaces are mocked —
  never concrete classes, never value objects.
- Follow **Arrange / Act / Assert** with visible separation:

```dart
test('returns cached monographs when offline', () async {
  // Arrange
  when(() => api.getMonographs(system: any(named: 'system')))
      .thenThrow(const SocketException('no network'));
  when(() => dao.getMonographs(system: any(named: 'system')))
      .thenAnswer((_) async => [monographFixture]);

  // Act
  final result = await repository.getMonographs(system: BodySystem.cardiovascular);

  // Assert
  expect(result, isA<Success<List<Monograph>>>());
  verify(() => dao.getMonographs(system: BodySystem.cardiovascular)).called(1);
});
```

- Name tests as behavioral sentences (see [naming.md](naming.md)).
- Cover the failure paths, not only the happy path: network errors, empty
  results, malformed DTOs, mapping edge cases.
- Fixtures: build test data with named factory constructors
  (`MonographFixture.cardiovascular()`), not giant object literals repeated
  per test.

## Widget Tests

- Pump the widget wrapped in a `ProviderScope` with overridden providers —
  never hit real repositories.
- Assert on user-visible outcomes: text, icons, enabled states, navigation
  calls.
- Prefer `find.byKey` or semantic labels over `find.byType` for fragile
  widget trees.

## Golden Tests

- Reserve for visually complex widgets: animation containers, monograph
  detail layouts, the consultation chat bubble.
- Run with `flutter test --update-goldens` only when a visual change is
  intentional, and review the diff.

## Integration Tests

- Cover the flows a user must never find broken: onboarding → browse a
  monograph → run a consultation → check history.
- They run against a real local database and mocked backend.
- **Restore shared state in tearDown.** Integration tests delete only the
  rows they created. A test that pollutes the database poisons every test
  that runs after it.

---

## Isolation Rules

1. **No global state mutation.** Never touch global singletons,
   `SharedPreferences` real instances, or environment variables in tests.
   Inject fakes through constructors or provider overrides.
2. **No test interdependence.** Tests run in any order, in parallel.
   If test B needs test A's side effects, the design is wrong.
3. **No real network, no real clock.** HTTP is mocked at the client;
   time is injected (`Clock` or a `DateTime Function()` parameter).
4. **No skipping to green.** A flaky test is fixed or deleted, never
   marked `skip:` "temporarily".

---

## Running Tests

```bash
flutter test                          # unit + widget
flutter test --coverage               # with coverage report
flutter test integration_test/        # integration (device/emulator required)
flutter analyze                       # static analysis — must be clean
```

## Reporting Convention

When reporting a green suite, quote **failures and assertions**, never
"passed" counts:

> ✅ `0 failures · 148 assertions`

Parallel runners can emit misleading "passed" totals; failures + assertion
counts are the reliable signal.

---

## Definition of Done (testing gate)

A pull request is mergeable only when:

- [ ] New logic has unit tests covering happy path and failure paths.
- [ ] New screens have widget tests for loading, error, and success states.
- [ ] `flutter analyze` reports zero issues.
- [ ] `flutter test` is green locally and in CI.
- [ ] Integration tests touched by the change still pass.
