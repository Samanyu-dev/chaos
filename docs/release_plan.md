# Orbit (Chaos) V1 Release Plan

This document maps out the prioritized schedule to move the Orbit codebase into a production-ready V1 release candidate.

---

## 1. Critical Priority (Functional & Visual Blockers)

### 1.1 Complete Map-OS Expense Integration
- **Tasks**:
  1. Add `@State private var memoryTabSegment: MemoryTabSegment = .moments` to `MapOSView`.
  2. Render Expense Pins (`💸` / `💳`) on Shibuya coordinates when the user is in the Memories/Expenses tab and selects the `Expenses` filter.
  3. When an Expense Pin is tapped, pan the camera, play a map pulse, and show an overlay with the payer, categories, splitting balances, and balance bubbles.
  4. Enable the top right HUD `+` button to launch the `showExpenseDrawer` sheet.
  5. Hook up the "Commit Split Bill" button to call a modified `addExpense` method in `AppViewModel` that registers coordinates.

### 1.2 Render Live Activity Widget
- **Tasks**:
  1. Embed `LiveActivityWidget` directly inside the bottom swipe-up directory card when the Home/Overview layer is active.

### 1.3 Stabilize Emoji Particle Allocations
- **Tasks**:
  1. Modify `emitMapReaction` in `MapOSView.swift` to remove particles from the array upon animation completion, resolving the memory leaks of invisible objects.

---

## 2. High Priority (Documentation & QA Tests)

### 2.1 Full Startup Documentation Deck
- **Tasks**:
  1. Create the comprehensive set of `.md` guides: `README.md`, `ARCHITECTURE.md`, `CONTRIBUTING.md`, `CODE_STYLE.md`, `DESIGN_SYSTEM.md`, `FEATURES.md`, `ROADMAP.md`, `API_DOCUMENTATION.md`, `ANALYTICS.md`, `TESTING.md`, `RELEASE_PROCESS.md`, `CHANGELOG.md`, `KNOWN_ISSUES.md`, `SECURITY.md`, and `LICENSE.md`.

### 2.2 App Store Metadata & Legal Pages
- **Tasks**:
  1. Create `APP_STORE_COPY.md`, `APP_STORE_KEYWORDS.md`, `APP_STORE_DESCRIPTION.md`, `PRIVACY_POLICY.md`, `TERMS_OF_SERVICE.md`, `TESTFLIGHT_GUIDE.md`, `RELEASE_CHECKLIST.md`, and `APP_REVIEW_NOTES.md`.

---

## 3. Medium Priority (Performance & Analytics)

### 3.1 Analytics Integration
- **Tasks**:
  1. Map trackable milestones (e.g. Onboarding, Auth, Memory uploads, Chaos spins, Theme switches) inside `AppViewModel` and `MapOSView`.

### 3.2 Performance and Framerate Polish
- **Tasks**:
  1. Audit SwiftUI list invalidations, ensure heavy gradient computations are optimized, and document runtime profile metrics.

---

## 4. Low Priority (Accessibility & Localization)

### 4.1 Accessibility Pass
- **Tasks**:
  1. Add accessibility labels, hints, and dynamic scaling support to interactive map buttons and tab bars.
