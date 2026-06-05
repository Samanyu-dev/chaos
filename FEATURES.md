# 🕹️ Feature Specifications — Orbit (Chaos)

This document catalogs the functional behavior, interaction designs, and implementation details for the core features of the Orbit (Chaos) platform.

---

## 1. Spatial Home Universe (`.home`)

- **Objective**: The landing cockpit for the active trip.
- **Visual Elements**:
  - *Trip Planet*: A rotating radial gradient sphere simulating a 3D planet floating in space.
  - *Cockpit Cards*: Glass cards displaying days left, upcoming flight itineraries, weather anomalies, and real-time active flight tracking.
  - *Live Activity Widget*: An embedded simulation of the lock-screen tracker, updating live coordinates of incoming group flights.

---

## 2. Map-as-an-OS & Global Layers

The app features a unified geographic coordinate system mapping simulated coordinate offsets directly to UI coordinates:
- **Signal Tracker (`.map`)**: Plots active coordinates of user profiles. Tapping a profile displays the active path trail and opens a reaction HUD to emit floating emoji bubbles.
- **Signal Emitter**: Spews custom emojis (like `🔥`, `💖`, `👑`) that drift upward and fade out. Includes a memory allocator cleanup loop preventing resource leaks.

---

## 3. Parallel Memories (`.memories`)

- **Objective**: Geolocate shared photo captures and stories on the exact spots they happened.
- **Tab Layout**: Features a customized glass segmented selector control:
  - **[Moments]**: Renders parallel memory pins. Tapping a pin brings up the full photo cluster card, showing different friend perspectives of the same event.
  - **[Expenses]**: Renders split bill expense pins (`💸` / `💳`) geolocated on the map.
- **Commit Flow**: Pinned memories include details on payer, description, category, and likes.

---

## 4. Shared Expenses (Split-Bills Mapping)

- **Objective**: Map trip expenses and manage live debt settlements.
- **Interaction Model**:
  - Add Expense: Click the top-right HUD `+` button to open the "Log Expense" drawer.
  - Users input title, amount, payer, and choose who to split with.
  - Upon tapping **"Commit Split Bill"**, the application calls `AppViewModel.addExpense`, generating a geolocated pins overlay on Shibuya coordinates with split balances.
  - Tapping an Expense Pin shows the balance bubbles (e.g. "Payer paid $240", "You owe $80").

---

## 5. Chaos Mode (`.chaos`)

- **Objective**: Drive spontaneous real-world group interaction and break decision paralysis.
- **Mechanics**:
  - Neon anomaly nodes sparkle on the map background.
  - Tapping the anomaly centers the camera and opens the **Chaos Wheel**.
  - Tapping **"Initiate Spin"** spins the wheel with decelerating arpeggios.
  - Returns a random spontaneous recommendation (e.g., "Sing karaoke until dawn in Golden Gai", "Try neon squid street food").

---

## 6. Group Spaces & Friendship OS (`.profile`)

- **Objective**: Establish the group's digital home base.
- **Features**:
  - *Streaks Node*: Tracks consecutive trips and days active together.
  - *Inside Jokes Node*: Pins memorable quotes to the Shibuya coordinates.
  - *Shared Playlist Widget*: Integrates a simulated Spotify/Apple Music glass track player.
  - *Theme Selector*: Live-switches the color presets and particle speeds of the active interface.
