# 0003 — Rive for Medical Animations

- **Status:** Accepted
- **Date:** 2026-09-07

## Context

The teaching path of saLuz differentiates itself through **animated graphic
material** at macro and microscopic levels (gas exchange, cardiac cycle).
Requirements:

- Interactive control: play/pause, zoom between macro/micro views,
  highlighting structures as the explanation progresses.
- 60fps on mid-range devices.
- Vector-based rendering: crisp on all densities, small file size.
- Maintainable by a developer, not a full-time animator.

Alternatives considered:

| Option | Assessment |
|:-------|:-----------|
| Lottie | Excellent for linear After Effects exports, but interactivity is limited (no runtime state machines, limited data binding); medical processes need state-driven control. |
| Custom `CustomPainter` | Full control and zero dependencies, but every animation is hand-coded; iteration is slow and visual review requires running the app. |
| Sprite/video sequences | Large assets, poor scaling, no interactivity. |
| Rive | Purpose-built for interactive animation: state machines controllable from code, data binding, vector feathering, official Flutter runtime, and a community with existing anatomy assets to start from. |

## Decision

Use **Rive** as the animation format and runtime for all medical animations,
driven through state machines with inputs bound from Flutter state.

## Consequences

**Easier:**

- Interactivity (zoom levels, highlighting, playback control) maps directly
  onto Rive state machine inputs set from Dart.
- Animations render at 60fps through the Rive renderer, independent of the
  widget tree's repaint cost.
- The Rive Community hosts anatomy assets that can be remixed, cutting the
  initial content-creation time significantly.
- One `.riv` asset serves Android, iOS, and any future platform.

**Harder (accepted):**

- Rive editor skills must be learned; complex animations (estimated ~8h
  each) are the largest single time risk in the roadmap — mitigated by
  starting from community assets.
- Low-end devices get a static SVG fallback (Phase 5, step 5.9) rather than
  degraded animation.
- `.riv` binary assets are not diff-friendly; versioning discipline
  (changelog per asset) is required.
