# 🔔 Relational Notification Strategy — Orbit (Chaos)

This document establishes the notification framework for Orbit (Chaos), detailing push notifications designed to feel personal and community-focused rather than transactional or spammy.

---

## 🎨 Copywriting Principles: Social & Cinematic

Orbit's notifications follow three rules:
1. **Relational Over Transactional**: Use names, inside joke cues, and active emojis. Avoid sterile system terms.
2. **Context-Aware**: Send notifications only when relevant (e.g. during a trip, near a location).
3. **Muted Volume**: Limit overall notification counts. Group events together to prevent noise.

---

## 📋 Telemetry & Push Trigger Catalog

### 1. Trip Countdown (Before Trip)
- **Objective**: Build excitement.
- **Timing**: 7 days before, 3 days before, and 24 hours before flight departure.
- **Copy Template**:
  > "🌍 Shibuya is waiting. The Trip Planet is fully generated. Leo is checking in!"

### 2. Proximity Signals (During Trip)
- **Objective**: Prompt real-world meetups.
- **Timing**: Triggered when a group member enters a $50\text{-meter}$ radius of another.
- **Copy Template**:
  > "📍 Proximity Radar: Leo is hunting vinyl 40 meters away. Send a signal reaction?"

### 3. Shared Expense Splits (During/After Trip)
- **Objective**: Manage expense split balance changes.
- **Timing**: 1 hour after a shared bill is committed.
- **Copy Template**:
  > "💸 Ramen Fuel logged: Lila paid $120. Your split is $40. Tap to settle up on the map."

### 4. Parallel Perspective Updates (After Trip)
- **Objective**: Prompt memory exploration.
- **Timing**: 2 hours after a friend uploads a photo to an existing memory anchor.
- **Copy Template**:
  > "📸 Lila added her perspective to the Shibuya Crossing pin. Tap to swipe the rewind stack."

### 5. Memory Anniversaries (Between Trips)
- **Objective**: Reignite planning loops.
- **Timing**: On the exact anniversary date of a completed trip.
- **Copy Template**:
  > "🗓️ One year ago today, the crew was singing karaoke in Golden Gai. Tap to revisit the Shibuya map."

---

## ⚙️ Frequency Caps & Quiet Hours

To prevent notifications from feeling spammy, we enforce client-side filters:
- **Quiet Hours**: Mute non-urgent notifications between 10:00 PM and 8:00 AM (local time).
- **Proximity Cooldown**: Prevent proximity notifications from triggering more than once every 12 hours for the same pair of friends.
- **Batching**: Group reaction notifications into a single update (e.g., "Kai and Lila sent you 5 reaction signals").
