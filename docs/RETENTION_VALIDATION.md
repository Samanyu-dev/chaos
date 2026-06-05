# 📈 Retention Validation Guide — Hypotheses & Gates

This document validates our retention loops, presenting hypotheses for why users remain active, invite others, and keep the application installed.

---

## 🔬 Core Product Hypotheses

### Hypothesis 1: Why would users return? (Daily Retention)
- **The Theory**: Friend groups will return to check the **Signal Tracker** status updates and react to their friends' active coordinates.
- **The Metric**: User opening frequency during active travel days.
- **Validation Gate**: Day 1 retention targets of **72%** and Day 7 targets of **48%** during group trips.

### Hypothesis 2: Why would users invite others? (Viral Growth)
- **The Theory**: Since the map layer is shared, it is empty without friends. Entering a Trip Space automatically prompts users to invite their travel partners to complete the Shibuya coordinate grid.
- **The Metric**: Number of SMS invites sent per active group during onboarding.
- **Validation Gate**: Group invitation completion rates of **85%** within the first hour of setting up a Trip Planet.

### Hypothesis 3: Why would users keep the app installed? (Long-Term Retention)
- **The Theory**: Orbit functions as the group's geolocated archive. By anchoring photo perspectives, bills, and inside joke pins to coordinates, the map becomes an emotional record that users want to revisit.
- **The Metric**: App launches outside of trip schedules.
- **Validation Gate**: Day 30 retention rates of **35%** and Day 90 targets of **25%**.

---

## 🚦 Retention Verification Dashboard

To evaluate if these hypotheses hold true during the TestFlight beta run, track these telemetry flags:

- **`retention_pulse`**: Logged whenever a user launches the app after a 24-hour gap.
- **`invite_conversion_ratio`**: Calculated by dividing accepted invites by sent invites.
- **`memory_revisit_frequency`**: Logs when users open the memories map layer to scroll through photo perspective cards from past trips.
