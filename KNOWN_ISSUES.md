# ⚠️ Known Issues & Sandbox Limitations — Orbit (Chaos)

This document tracks known issues, sandbox constraints, and mocked subsystems within the V1.0.0-RC1 release of Orbit (Chaos).

---

## 🛰️ 1. Mocked & Simulated Subsystems

Since Orbit is designed as a standalone high-fidelity prototype before integration with full backend APIs and sensors, several modules use simulated interfaces:

### Simulated Geolocation offsets
- **Issue**: Map panning and pins use static `latOffset` and `lonOffset` parameters relative to Shibuya coordinates rather than reading GPS streams.
- **Workaround**: Simulated coordinates are pre-configured in `MockData.swift`.
- **Target Fix**: CoreLocation integration is scheduled for **V1.1.0**.

### Mock Spotify Playlist Widget
- **Issue**: The playlist player on the Group Profile layer uses static album cover image buffers and doesn't stream music from a streaming service.
- **Target Fix**: Apple Music Web API authentication is scheduled for **V1.2.0**.

### Simulated Live Activities
- **Issue**: Lock Screen Live Activities are rendered as mock Swift views in the pull-up directory drawer, rather than being managed by iOS ActivityKit daemon.
- **Target Fix**: ActivityKit implementation is scheduled for **V1.2.0**.

---

## 🛠️ 2. Performance & UI Constraints

### Overlap rendering on Old Devices
- **Issue**: Multiple overlapping glass cards using `.ultraThinMaterial` backgrounds can lead to framerate drops (under 40 FPS) on devices older than iPhone 11.
- **Mitigation**: Switch the active color theme to **Arctic Minimal** which reduces glow layers and turns off heavy animation loops.
- **Target Fix**: Group background layers and dynamically disable blurred materials on legacy devices.
