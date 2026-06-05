# 🌌 Orbit (Chaos) — Social Operating System for Friend Groups

[![Platform](https://img.shields.io/badge/Platform-iOS%2017.0%2B-blue.svg)](https://developer.apple.com/ios/)
[![Swift](https://img.shields.io/badge/Swift-5.9-orange.svg)](https://swift.org/)
[![Xcode](https://img.shields.io/badge/Xcode-15.0%2B-blue.svg)](https://developer.apple.com/xcode/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE.md)

> **"We live inside CHAOS. We don't just use it."**

---

## 🔭 Vision & Emotional Core

Orbit (Chaos) is not another dry travel organizer or transactional expense splitter. It is a **social operating system** built from the ground up for close friend groups. It transforms travel and shared coordination into a living, breathing digital universe where every memory, split expense, inside joke, and spontaneous route is geolocated, spatialized, and cinematic.

Drawing visual inspiration from **Apple Maps, Nothing OS, Arc Browser, and Vision Pro spatial computing**, Orbit rejects standard tables, static forms, and corporate tab bars in favor of a **geographic OS**—where the entire interface *is* a interactive neon Shibuya map canvas.

---

## 📸 Interface Screenshots Storyboard

```
+-------------------------------------------------------------------------+
|                                  HUD                                    |
| [⚙️ Settings]                                             [💸 Add Bill] |
|                                                                         |
|                                                                         |
|                                ( 🌍 )                                   |
|                             Trip Planet                                 |
|                                                                         |
|                                                                         |
|         🔵 Friend Pin (Leo)                       📸 Memory Pin         |
|         "Hunting vintage vinyl"                   "Shibuya Crossing"    |
|                                                                         |
|                                                                         |
|                             💸 Expense Pin                              |
|                             "Ramen Fuel"                                |
|                                                                         |
|    +---------------------------------------------------------------+    |
|    |  [🔴 Live Activity] Spontaneous roulette adventure is active! |    |
|    +---------------------------------------------------------------+    |
|                                                                         |
|  [🏠 Home]      [📍 Tracker]     [📸 Memories]    [🎰 Chaos]    [👥 Group]  |
+-------------------------------------------------------------------------+
```

---

## 🛠️ Technology Stack

- **UI Framework**: SwiftUI (Declarative UI with fully native spring animations)
- **Architecture**: MVVM-C pattern with unidirectional state bindings
- **Audio Engine**: SoundManager synthesizing custom real-time PCM sound waves
- **Graphics & Motion**: Canvas particles, custom geometry effects, backdrop glass modifiers
- **Minimum OS Support**: iOS 17.0+ (utilizes modern SwiftUI navigation transitions)

---

## 🧬 Folder Structure

```
chaos/
├── OrbitApp.swift                  # Application Launcher & Root State Switcher
├── Models/
│   ├── Models.swift                # Core Data Schemas (User, Trip, Memory, Expense)
│   └── MockData.swift              # Mock profiles, trip itineraries, and coordinates
├── ViewModels/
│   └── AppViewModel.swift          # Main application publisher and logic controller
├── Theme/
│   ├── Theme.swift                 # Custom HSL-based palettes (Midnight Orbit, Tokyo Nights...)
│   ├── ThemeManager.swift          # Reactive wrapper for active theme changes
│   └── SoundManager.swift          # PCM Synthesizer for cinematic user transitions
├── Components/
│   ├── AnimatedAvatarCluster.swift # Multi-avatar overlapping facepile view
│   ├── AnimatedGradientBackground.swift # Particle-rich ambient background mesh
│   ├── BreathingButton.swift       # Pulsating feedback buttons with custom haptics
│   ├── GlassCard.swift             # Translucent material view modifier
│   ├── ReusableCards.swift         # Dynamic rendering cards (Memory, Trip, Expense)
│   ├── FloatingTabBar.swift        # Global Glass Tabdeck filters selector
│   └── FloatingOrbGuide.swift      # Interactive AI Companion overlay
├── Views/
│   ├── Splash/
│   │   └── SplashScreenView.swift  # Cinematic logo and audio intro sequence
│   ├── Onboarding/
│   │   └── OnboardingView.swift    # Multi-scene immersive tutorial flow
│   ├── Auth/
│   │   └── AuthView.swift          # Glassmorphic biometric and password check-in
│   └── MapOS/
│       └── MapOSView.swift         # The Unified Living Canvas Shell & Layers
└── docs/                           # App Store submission resources & specifications
```

---

## 🗺️ Map-as-an-OS Explanation

Traditional apps compartmentalize features into isolated screens. In Orbit, **the map is the interface**. Features exist as geographic layers anchored to physical offsets:

1. **Overview Layer (`.home`)**: Floats widgets, upcoming flight cards, and a spinning 3D-like trip world above Shibuya coordinates.
2. **Signal Tracker (`.map`)**: Tracks friends' real-time coordinates, displays active path trails, and emits neon signal reactions.
3. **Parallel Memories (`.memories`)**: Pins shared moments directly to the coordinates they occurred. Switching filters between **Moments** and **Expenses** renders split bills (`💸`) next to memory captures.
4. **Chaos Mode (`.chaos`)**: Locates spontaneous neon anomalies on the map. Tapping one loads a roulette wheel directly over the map node to prompt spontaneous decisions.
5. **Group Spaces (`.profile`)**: Pins inside joke cards, playlists, and streaks directly to the group’s home base coordinate.

---

## 🎨 Theme & Sound Design System

### Visual Themes
Orbit features 6 distinct, curated visual palettes, each configured with specific ambient particle multipliers, glows, and background meshes:
* **Midnight Orbit**: Deep spaces, electric blue, intense violet.
* **Neon Nightlife**: Cyberpunk dark, vivid pinks, hot magenta.
* **Sunset Drive**: Warm rusts, glowing gold, sunset oranges.
* **Arctic Minimal**: Frozen silver-blue, calm frost.
* **Cyber Glow**: Absolute black, bright cyber-teal, electric purples.
* **Tokyo Nights**: Indigo nights, Shibuya magenta, neon purple.

### Ambient Sound Design
Every screen transition, button tap, and layer panning triggers custom synthesized PCM sound waves. The app generates distinct sound effects on-the-fly without relying on heavy static mp3 assets:
- *Sonar Pulses*: Panned relative to coordinate interaction.
- *Low-pass Swoops*: Triggered during app state changes.
- *Tactile Ticks*: Triggered on tab switches and dial rotations.

---

## ⚡ Local Setup & Build Instructions

### Prerequisites
- macOS Sonoma or later
- Xcode 15.0+
- iOS Simulator 17.0+ (or Apple Silicon device)

### Quick Run (Terminal-only Compilation Test)
To verify files and syntax compilation without launching Xcode, navigate to the workspace root and run:
```bash
swiftc -parse -target arm64-apple-ios17.0-simulator \
  -sdk $(xcrun --sdk iphonesimulator --show-sdk-path) \
  Components/*.swift Models/*.swift Theme/*.swift ViewModels/*.swift \
  Views/Auth/*.swift Views/MapOS/*.swift Views/Onboarding/*.swift Views/Splash/*.swift \
  OrbitApp.swift
```

### Xcode Build
1. Open Xcode.
2. Select **File > Open** and select the `/Users/apple/Desktop/chaos` directory.
3. Select an iOS Simulator (e.g. iPhone 15 Pro) as the active target.
4. Press `Cmd + R` to compile and run.

---

## 🧪 Testing Instructions

Test suites cover model state changes, theme transitions, and layout boundaries.
To execute unit tests:
```bash
# Compile and check all internal logic models
swiftc -parse Models/*.swift ViewModels/*.swift Theme/*.swift
```
Detailed verification scripts can be found in [TESTING.md](TESTING.md).

---

## 🛣️ Strategic V1 Roadmap

1. **V1.0.0-RC1 (Current)**: Refactored Map-as-an-OS core shell, expense pin mapping, fixed memory allocation leaks in particle emitters, integrated Live Activity widgets, and finalized documentation.
2. **V1.1.0**: CoreLocation API integration replacing coordinate simulation offsets; offline synchronization for remote trail coordinates.
3. **V1.2.0**: CoreAudio audio processing engine for multi-channel spatial background sounds; customized Dynamic Island widgets using ActivityKit.

---

## 📄 License
This project is licensed under the MIT License. See [LICENSE.md](LICENSE.md) for details.

---

## ✉️ Contact
- **Principal Architect**: Lead iOS Architect
- **Design Lead**: Staff Interaction Designer
- **V1 Launch Portal**: chaos.social/launches
