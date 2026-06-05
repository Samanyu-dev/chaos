# 📖 API Documentation — Orbit (Chaos)

This document contains specifications for the internal APIs, ViewModels, manager classes, and data models that drive the Orbit (Chaos) application.

---

## 1. AppViewModel State Publishers

`AppViewModel` acts as the single source of truth for UI states.

### 🗼 Core State Publishers

| Publisher | Type | Description |
| :--- | :--- | :--- |
| **`appState`** | `AppState` | Handles navigation switches (`.splash`, `.onboarding`, `.auth`, `.mainTab`). |
| **`activeTab`** | `ActiveTab` | Manages the active map layer filtration deck (`.home`, `.map`, `.memories`, `.chaos`, `.profile`). |
| **`currentUser`** | `User` | Stores profile data, status, coordinates, and active emojis for the logged-in user. |
| **`friends`** | `[User]` | Array of geolocated friend nodes. |
| **`expenses`** | `[Expense]` | Stores geolocated split-bill objects. |
| **`isChaosSpinning`**| `Bool` | Triggers wheel rotation animations in Chaos Mode. |

### 🕹️ State Transition Methods

#### `completeSplash()`
Transitions state from `.splash` to `.onboarding` with a custom spring curve and low-pass audio transition.

#### `completeOnboarding()`
Transitions state from `.onboarding` to `.auth`.

#### `completeAuth()`
Transitions state from `.auth` to `.mainTab`.

#### `addExpense(title: String, amount: Double, payer: User, splitUsers: [User], category: String, latOffset: Double, lonOffset: Double)`
Calculates split values, constructs a new `Expense`, and inserts it into the `expenses` array with geographical coordinates.

---

## 2. SoundManager Audio System

`SoundManager` synthesizes raw PCM waveforms using the `AVFoundation` framework.

```swift
class SoundManager: ObservableObject {
    static let shared = SoundManager()
    
    // Core Playback Controls
    func playTick()
    func playTransition()
    func playSonarPulse()
}
```

### Synthesis Mathematics:
- **`playTick()`**: Fills a `5ms` audio buffer with high-frequency sine-wave decay to simulate a physical micro-switch click:
  $$f(t) = \sin(2\pi \cdot 3000 \cdot t) \cdot e^{-1000t}$$
- **`playTransition()`**: Sweeps a synthesizer oscillator from $100\text{ Hz}$ to $800\text{ Hz}$ over $600\text{ milliseconds}$:
  $$f(t) = \sin\left(2\pi \cdot \left(100 + \frac{700t}{0.6}\right) \cdot t\right)$$
- **`playSonarPulse()`**: Generates a standard resonance ping decaying over $1.5\text{ seconds}$:
  $$f(t) = \sin(2\pi \cdot 440 \cdot t) \cdot e^{-3.5t}$$

---

## 3. Data Schema Specifications

All structural models are defined in `Models/Models.swift`.

### `User`
```swift
struct User: Identifiable, Hashable {
    var id: UUID
    var name: String
    var username: String
    var avatar: String // Emoji representation
    var status: String
    var activeEmoji: String
    var latOffset: Double // Map coordinate positioning
    var lonOffset: Double // Map coordinate positioning
    var isMe: Bool
}
```

### `Expense`
```swift
struct Expense: Identifiable, Hashable {
    var id: UUID
    var tripId: UUID
    var title: String
    var amount: Double
    var payer: User
    var splits: [ExpenseSplit]
    var category: String
    var timestamp: Date
    var latOffset: Double // Shibuya mapping offset
    var lonOffset: Double // Shibuya mapping offset
}
```
Quote and coordinate settings are detailed in the [Models.swift](Models/Models.swift) file.
