# 🛡️ Crash Risk Report — Orbit (Chaos) V1.0.0-RC1

This report analyzes technical stability risks, code concurrency, optional force-unwraps, and memory usage patterns in Orbit.

---

## 💥 1. Force Unwraps & Optional Safety Analysis

We searched the codebase for force-unwraps (`!`). While a few exist, they are insulated from crash risks:

### 1.1 `[Color].randomElement()!` (MapOSView.swift:853)
- **Code**:
  ```swift
  accentColors: [[Color(hex: "ff007f"), Color(hex: "7000ff")].randomElement()!, [Color(hex: "00f5d4"), Color(hex: "3a86ff")].randomElement()!]
  ```
- **Risk Assessment**: **Low**. The collections are statically declared inline array literals containing two non-nil elements. Thus, `randomElement()` will never return `nil`.

### 1.2 `theme.rawValue.split(separator: " ").first!` (MapOSView.swift:781)
- **Code**:
  ```swift
  Text(theme.rawValue.split(separator: " ").first!)
  ```
- **Risk Assessment**: **Low**. The `theme.rawValue` represents non-empty string literals defined by the `OrbitTheme` cases (e.g., `"Midnight Orbit"`). Splitting by space will always yield at least one substring.

---

## 🧵 2. Threading & Concurrency Checks

### 2.1 UI State Updates on Main Thread
All mutations to `@Published` properties (such as `self.currentUser`, `self.expenses`, `self.isChaosSpinning`) are executed on the Main Thread.
- **Example**: `spinChaosWheel()` uses a `DispatchQueue.main.asyncAfter` closure to deliver state updates, ensuring SwiftUI view invalidations do not trigger main-thread warnings.

### 2.2 Synthesized Audio Offloading
To prevent main thread blocking during PCM wave synthesis, `SoundManager.shared.playSynthTone` dispatches the entire compilation logic to a high-priority background thread:
```swift
DispatchQueue.global(qos: .userInteractive).async { ... }
```
Haptic feedback generation is correctly dispatched back to `DispatchQueue.main.async`.

---

## 🔋 3. Memory Leak & Retain Cycle Checks

### 3.1 Emoji Particles Emitters (MapOSView.swift)
- **Prior Hazard**: Emoji reaction models were added to a list but never purged from memory. Repeated tapping would create thousands of invisible, zero-opacity SwiftUI nodes.
- **V1 Fix**: Emitter structures now run a clean UUID purge queue. After a $1.2\text{-second}$ delay, the corresponding particle ID is filtered out from the active collection:
  ```swift
  DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
      self.particles.removeAll(where: { $0.id == particle.id })
  }
  ```

### 3.2 Sound Engine Teardown
To prevent background accumulation of active `AVAudioEngine` objects, the buffer schedule closure stops the node and terminates resources within `0.1s` of playback completion:
```swift
player.scheduleBuffer(buffer) {
    DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 0.1) {
        engine.stop()
    }
}
```

---

## 📡 4. Location Permission & Offline Failures

### 4.1 Missing Permission Fallback
Orbit does not crash when device-level GPS queries fail. Coordinates are simulated as coordinate offsets from the Shibuya epicenter (`MockData.me.latOffset`).
- **Production Gate**: Before migrating to hardware coordinates, optional bindings must be established to catch `CLAuthorizationStatus.denied` and fallback safely.

### 4.2 Offline Storage Resilience
No active network connection is required to navigate Shibuya, log expenses, or switch themes. Data remains stored locally in memory buffers.
