# 🚦 Launch Blockers Backlog — Orbit (Chaos) V1.0.0-RC1

This document lists launch readiness issues categorized by impact level. **Submissions require 0 Critical and 0 High blockers.**

---

## 📊 Blockers Summary

- **Critical Priority**: **0**
- **High Priority**: **0**
- **Medium Priority**: **2**
- **Low Priority**: **2**

---

## 🚫 1. Critical Priority Blockers (Current count: 0)
*No blockers remain. Core features, coordinates split bills, emitter cleanups, and sound engine compilation checks are verified.*

---

## ⚠️ 2. High Priority Blockers (Current count: 0)
*No blockers remain. User review guidelines, privacy policy, and metadata terms are prepared.*

---

## ⚡ 3. Medium Priority Issues (Target: V1.1.0 Integration)

### 3.1 Live CoreLocation API Integration
- **Issue**: Coordinates are panned using simulated offsets rather than active GPS chips.
- **Impact**: Users cannot track movements outside the simulated Shibuya coordinate offsets.
- **Resolution**: Integrate Apple's CoreLocation framework and update `Models.swift` with hardware coordinates.

### 3.2 SwiftData/SQLite Database Layer
- **Issue**: Data additions (expenses, jokes) are saved in memory and reset upon app termination.
- **Impact**: Users lose logged split bills when closing the application.
- **Resolution**: Setup SwiftData containers to persist model schemas locally.

---

## 📉 4. Low Priority Issues (Target: V1.2.0 Polish)

### 4.1 Real Music Streaming SDK Integration
- **Issue**: The playlist player on the Group layer uses visual mockups and does not stream tracks.
- **Impact**: Aesthetic/functional limit.
- **Resolution**: Integrate Spotify iOS SDK to link real playlists.

### 4.2 Dynamic Audio Frequency Shifts
- **Issue**: PCM synthesized sound waves play at fixed volumes and frequencies.
- **Impact**: Lacks the dynamic panning experience of Apple's spatial engine.
- **Resolution**: Integrate Apple's spatial audio engine to adjust sound parameters based on coordinate distance.
