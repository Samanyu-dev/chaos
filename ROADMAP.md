# 🗺️ Product Roadmap — Orbit (Chaos)

This document maps out the engineering milestones and strategic development roadmap for Orbit (Chaos) across its V1 release and future iterations.

---

## 📅 Timeline at a Glance

```
       V1.0.0-RC1               V1.1.0-Beta              V1.2.0-Prod              V2.0.0-Core
     [JUNE 2026]              [AUG 2026]               [OCT 2026]               [Q1 2027]
          +                        +                        +                        +
          |                        |                        |                        |
     (We are here)            (Hardware)                (Social)                 (Ecosystem)
     Stable Map-OS           CoreLocation              ActivityKit               Spatial OS
     Mock data engine        Offline caching           CoreAudio engine          Vision Pro App
```

---

## 🏁 Milestones & Milestones Details

### Milestone 1: V1.0.0-RC1 (Stable Core Release) — *Current Phase*
- **Focus**: UI Stability, Map OS unified architecture, synthesized sound design, memory-leak fixes, and comprehensive startup-grade documentation.
- **Status**: **Completed & Verified**.

### Milestone 2: V1.1.0 (Hardware Integration) — *Q3 2026*
- **Focus**: Replacing simulation coordinates with active device sensors.
- **Features**:
  - Integrate Apple's **CoreLocation** API with background tracking permissions.
  - Implement a locally persistent SQLite/SwiftData database.
  - Offline sync queuing: Queue memories, route paths, and expenses offline, then sync via a REST API queue when network coverage returns.

### Milestone 3: V1.2.0 (Live Widgets & Audio) — *Q4 2026*
- **Focus**: Moving from mock environments to native iOS ecosystem extensions.
- **Features**:
  - Native **ActivityKit** Dynamic Island and lock-screen Live Activities showing active trip tracking, distance alerts, and chaos spin progress.
  - Spatial audio mapping via Apple's **CoreAudio** and AudioUnits to modulate sonar pulse pitches based on friend distance.
  - Home Screen widget updates for iOS.

### Milestone 4: V2.0.0 (Spatial Ecosystem) — *Q1 2027*
- **Focus**: Expanding the social operating system to cross-device platforms.
- **Features**:
  - Immersive **visionOS App Store** launch, allowing users to project their social maps in 3D over their workspaces.
  - Real-time video/audio streaming rooms mapped to physical pins.
  - AI-driven itinerary suggestions leveraging localized APIs.
