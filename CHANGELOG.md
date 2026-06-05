# 📝 Changelog — Orbit (Chaos)

All notable changes to the Orbit (Chaos) project will be documented in this file.

---

## [1.0.0-RC1] — 2026-06-05

This release candidate transforms Orbit from a feature-separate prototype into a fully unified **Map-as-an-OS** social travel experience.

### 🚀 Added
- **Map-as-an-OS Integration**: Replaced standard static TabViews with a single, persistent vector Shibuya Map Canvas background.
- **Geolocated Split Bills**: Added an `[Moments] [Expenses]` segmented control deck in the memories layer. Pinned expenses appear as neon `💸` icons on Shibuya offsets. Tapping pins displays split details in a slide-up card.
- **Commit Split Bill Flow**: Configured the HUD `+` button to allow users to input title, amount, and splitters, panned dynamically to coordinates.
- **Live Activity Widget**: Embedded the interactive `LiveActivityWidget` directly inside the bottom swipe-up directory timeline drawer.

### 🔧 Fixed
- **Emoji Particle Memory Leak**: Fixed an issue in `MapOSView.swift` where emitted reaction particles were kept in memory indefinitely after fading out. Added an explicit UUID cleanup loop to automatically prune models.
- **Onboarding Navigation Controls**: Fixed onboarding page-transition bugs, replacing manual page offsets with clean spring transitions.

### 📖 Documentation
- Generated root-level guides including `README.md`, `ARCHITECTURE.md`, `CONTRIBUTING.md`, `CODE_STYLE.md`, `DESIGN_SYSTEM.md`, `FEATURES.md`, `ROADMAP.md`, `API_DOCUMENTATION.md`, `ANALYTICS.md`, `TESTING.md`, `RELEASE_PROCESS.md`, `CHANGELOG.md`, `KNOWN_ISSUES.md`, `SECURITY.md`, and `LICENSE.md`.
- Prepared App Store marketing copy and reviewer guides in the `/docs` directory.
