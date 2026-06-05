# 👥 The Friendship Engine — Core Architecture

This document outlines the design, data structures, and mechanics of the unified **Friendship Engine**, the relational core of Orbit (Chaos) that shifts its purpose from a travel utility to a friendship operating system.

---

## 🧬 Architectural Principles

The Friendship Engine is built on a single premise: **relationships are anchored to shared locations**. The engine translates interactions into geographical anchors, streaks, and emotional timelines.

```
                  +-----------------------------------+
                  |        Friendship Engine          |
                  +-----------------------------------+
                                    |
     +------------------------------+------------------------------+
     |                              |                              |
     v                              v                              v
[Geographic Bonds]         [Parallel Rewinds]             [Group Evolution]
Inside Joke pins,          Perspective Swipes,            Streaks tracking,
Shared Playlist widgets    Anniversary alerts             Shared Theme syncs
```

---

## 🛠️ Core Subsystems

### 1. Geographic Bonds (Inside Jokes & Playlists)
- **Inside Jokes Pins**: Friends drop quotes directly on Shibuya streets where they happened. In V1, the `InsideJoke` model (`Models.swift:86`) records quote contents, author, and coordinate offsets. Tapping a joke pin on the profile layer displays the text and triggers audio ticks.
- **Shared Playlists**: Pins a collective group soundtrack card directly to the group home node on the map, syncing song queues as users listen.

### 2. Parallel Rewind (Perspective Swipes)
- **Shared Perspective Stacks**: The `Memory` schema (`Models.swift:37`) uses a `perspectiveName` and `imageURL` model. Tapping a memory capsule opens the parallel memory cards stack, allowing friends to swipe left and right to see Lila’s, Kai’s, and Leo’s perspectives of the exact same event.
- **Anniversary Alerts**: Alerts that pop up on the Dynamic Island on the exact calendar day a memory was logged in previous years.

### 3. Group Evolution (Streaks & Theme Sync)
- **Friendship Streaks**: Tracks consecutive days active and trips completed together.
- **Shared Theme Sync**: When a group member updates the visual skin (such as switching to **tokyoNights**), the theme changes on the map of all active group members, reflecting the group’s shared visual tone.

---

## 📈 Database Schema Integration (V1 Models)

The engine leverages structures already defined in the application's models:

```swift
// Models.swift excerpt
struct InsideJoke: Identifiable, Hashable {
    var id = UUID()
    var quote: String
    var author: String
    var latOffset: Double // Shibuya map anchor
    var lonOffset: Double // Shibuya map anchor
}
```
Inside joke quotes are pre-populated in `MockData.swift` and loaded dynamically onto the Shibuya canvas when the profile layer is active.
