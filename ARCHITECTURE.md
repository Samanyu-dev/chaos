# 🏛️ Architecture Documentation — Orbit (Chaos)

This document details the architectural patterns, component layouts, and engineering designs that support the Orbit (Chaos) social operating system.

---

## 1. Architectural Overview & Design Pattern

Orbit uses an adapted **MVVM-C (Model-View-ViewModel-Coordinator)** structure with a reactive data flow managed by Swift's **Combine** framework.

```
+-----------------------------------------------------------------------------------+
|                                 App Launcher                                      |
|                               (OrbitApp.swift)                                    |
+-----------------------------------------------------------------------------------+
                                          |
                                          v
+-----------------------------------------------------------------------------------+
|                              Global AppState Router                               |
|            [.splash] -> [.onboarding] -> [.auth] -> [.mainTab (MapOSView)]        |
+-----------------------------------------------------------------------------------+
                                          |
                        +-----------------+-----------------+
                        |                                   |
                        v                                   v
+-----------------------------------------------+ +---------------------------------+
|               Master ViewModel                | |          Theme Manager          |
|              (AppViewModel.swift)             | |       (ThemeManager.swift)      |
+-----------------------------------------------+ +---------------------------------+
                        |                                   |
    +-------------------+-------------------+               | (Injects colors/glows)
    |                   |                   |               v
    v                   v                   v   +---------------------------------+
[.home Layer]    [.memories Layer]    [.chaos Layer]    |         Map View Canvas         |
(Overview Cards) (Photo & Expense)   (Roulette Spin)    |        (MapOSView.swift)        |
    |                   |                   |   +---------------------------------+
    +-------------------+-------------------+
                        |
                        v
         (Spatial overlays anchored to pins)
```

---

## 2. Navigation & Router Flow

Rather than using SwiftUI's standard `TabView` or a navigation stack that rebuilds views, Orbit utilizes a single, persistent **Unified Map Canvas** (`MapOSView.swift`).

### State Redirection
The global state flow is defined in `OrbitApp.swift`:
1. **`.splash`**: Renders `SplashScreenView`, initializes audio buffers, and plays a cinematic sweep before transitioning.
2. **`.onboarding`**: Plays multi-stage interactive guide pages introducing users to spatial maps.
3. **`.auth`**: Enforces a futuristic glass-morphic passcode or facial scan lock screen.
4. **`.mainTab`**: Boots the central `MapOSView`.

### Layer Filtration
Inside `MapOSView`, navigation is represented by changing the `.activeTab` enumeration in `AppViewModel`. A change in `activeTab` panned is accompanied by camera zooming, changes in focus coordinates, and overlay filters:
- **`home`**: Sets camera focus on the central Trip Planet widget, bringing the dashboard up.
- **`map`**: Zooms close to friend pins and trail tracking lines.
- **`memories`**: Centers on memories and expense nodes.
- **`chaos`**: Centers on the spontaneous neon anomaly node.
- **`profile`**: Centers on the group home base coordinate node.

---

## 3. Map OS Engine & Projection

Since Orbit represents a **Map-as-an-OS**, map coordinates are calculated using simulated geographical offsets on a high-fidelity vector background canvas.

### Anchor Pins
Pins are geolocated relative to Shibuya, Tokyo. The coordinate projection calculates view offsets on screen:
```swift
let scale: CGFloat = 8000
let xOffset = CGFloat(item.lonOffset) * scale
let yOffset = CGFloat(item.latOffset) * scale
```
This maps coordinate changes directly to `x` and `y` offsets within a custom scrolling scroll container or dragging canvas, enabling smooth inertia panning and zooming without standard map-kit overhead.

---

## 4. Audio Synthesis (SoundManager)

To maintain rich, high-fidelity ambient feel, the application includes a **synthesized audio generator** (`SoundManager.swift`) that outputs custom audio wave buffers.

### PCM Wave Buffer Synthesis
Instead of reading massive static `.mp3` or `.wav` assets, `SoundManager` initializes audio signals via Apple's `AVFoundation` engine and writes sine/square wave mathematical curves directly to a PCM buffer:
- **Transition swoops**: Synthesizes a sweep frequency from $100\text{ Hz}$ to $800\text{ Hz}$ with linear frequency growth.
- **Feedback ticks**: Outputs a short burst of noise (5 milliseconds) to simulate high-frequency plastic taps.
- **Sonar pulses**: Generates a sine wave envelope decaying exponentially to represent proximity sensors.

---

## 5. Widget & Dynamic Island Architectures

### Live Activity Widget (`LiveActivityWidget`)
- Stored in `Components/EcosystemMockups.swift`.
- Features glass-morphic styling, progress bars, and custom avatars.
- Integrated into the bottom slider card of the Home View to simulate iOS system locks.

### Dynamic Island Mockup (`DynamicIslandMockup`)
- Simulates the hardware island pill at the top of the viewport.
- Expands dynamically with custom spring animations (`response: 0.4, dampingFraction: 0.65`) to display contextual state alerts.
- Connected directly to changes in the active state indices (e.g. tracking when a chaos spin is triggered).

---

## 6. Realtime, Offline, and Scalability Strategy

- **Realtime Sync**: Designed to hook into standard WebSockets or Firebase Firestore real-time collections.
- **Offline Mode**: Implements a geographical cache layer. Users can post memories or add split expenses offline; coordinates are recorded locally and queue up for background sync when the network returns.
- **Scalability**: All models implement `Hashable` and `Identifiable` protocols, making them compatible with SwiftUI's `LazyVStack` and grid systems to handle hundreds of localized markers with minimal rendering overdraw.
