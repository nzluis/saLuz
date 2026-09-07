# AGENTS.md — saLuz

This file is the entry point for any agent or developer working on this repository.
Read it first. Follow it always.

---

## What saLuz Is

saLuz is a mobile health education app for Android and iOS with two connected paths:

1. **Teaching & Documentation** — Monographs on human physiology and
   pathophysiology, illustrated with animated graphic material (macro and
   microscopic level). Patients learn how a body system works and what changes
   in a specific disease.
2. **Professional Consultation** — A medical consultation agent that uses the
   documented knowledge base to relate symptoms, signs, and user-provided
   indicators, guiding users toward documented pathologies that match their
   criteria. **It is not a diagnostic tool.**

Primary data source: **PubMed E-utilities API** (free, 36M+ biomedical papers).

---

## Stack

| Layer | Technology |
|:------|:-----------|
| Mobile app | Flutter 3.24+ / Dart 3.x |
| State management | Riverpod 2.x |
| Navigation | GoRouter |
| Local database | Drift (SQLite) + `sqlite_vector` |
| Animations | Rive |
| On-device embeddings | MediaPipe Text Embedder |
| Backend | Node.js 22 + Fastify + TypeScript |
| Cloud vector DB | Turso (libSQL) |
| Cloud LLM | Groq API (Llama 3.3 70B) |
| Medical data | PubMed E-utilities API |

---

## Essential Commands

```bash
# App
flutter pub get                    # Install dependencies
flutter run                        # Run on connected device/emulator
flutter analyze                    # Static analysis (must be clean)
flutter test                       # Unit + widget tests

# Code generation (Riverpod, Drift, injectable)
dart run build_runner build --delete-conflicting-outputs

# Backend (from backend/ directory)
npm run dev                        # Development server
npm test                           # Backend tests
```

---

## Project Structure

```
saLuz/
├── AGENTS.md                  # This file
├── docs/
│   ├── README.md              # Documentation index
│   ├── conventions/           # How we write code (architecture, naming, testing, style)
│   ├── decisions/             # ADRs — why we chose what we chose
│   ├── knowledge/             # Deep-dive guides (Flutter, Rive, PubMed)
│   └── plan/
│       └── phases.md          # Project roadmap and phase tracking
├── lib/
│   ├── app/                   # App bootstrap, shell, lifecycle
│   ├── core/                  # Cross-cutting infrastructure (network, storage, env)
│   ├── design_system/         # Theme, colors, typography, base widgets
│   ├── features/              # Feature modules (content, consultation, …)
│   │   └── <feature>/
│   │       ├── data/          # Repository implementations, DTOs, data sources
│   │       ├── domain/        # Entities, repository contracts, business rules
│   │       └── presentation/  # Screens, widgets, Riverpod providers
│   └── shared/                # Feature-agnostic utilities
├── test/                      # Mirrors lib/ structure
├── integration_test/          # End-to-end flows
└── backend/                   # Node.js API (PubMed client, content pipeline)
```

---

## Golden Rules

1. **Architecture is sacred.** Dependencies flow `presentation → domain ← data`.
   Never the reverse. Never import Flutter or frameworks in `domain/`.
2. **Naming over comments.** If you need a comment to explain what something does,
   rename it. Comments are for *why*, never *what*.
3. **Tests are first-class citizens.** No feature is done without tests.
4. **Fail fast, fail visible.** Errors surface early and clearly, never silently.
5. **Privacy first.** Medical data defaults to on-device processing.
6. **Documentation is alive.** Decisions go in ADRs. This file and `docs/` are
   updated in the same commit as the change they describe.
7. **Small steps.** Atomic commits, small PRs, frequent reviews.

---

## Extended Documentation

- **How to structure code:** [`docs/conventions/architecture.md`](docs/conventions/architecture.md)
- **How to name things:** [`docs/conventions/naming.md`](docs/conventions/naming.md)
- **How to test:** [`docs/conventions/testing.md`](docs/conventions/testing.md)
- **Dart style rules:** [`docs/conventions/dart-style.md`](docs/conventions/dart-style.md)
- **Why decisions were made:** [`docs/decisions/`](docs/decisions/)
- **Project roadmap:** [`docs/plan/phases.md`](docs/plan/phases.md)

---

## Medical Disclaimer

saLuz is an educational tool. It must never present itself as a diagnostic
service. Every consultation response must include a visible reminder that the
information does not replace professional medical advice.
