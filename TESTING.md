# 🧪 Testing & Quality Assurance Manual — Orbit (Chaos)

This document contains testing protocols, automated compile test sequences, and step-by-step manual QA verification scenarios to validate Orbit (Chaos).

---

## 💻 Automated Compilation & Integrity Checks

Since Orbit runs as a native iOS app, verify code integrity and compiler diagnostics by targeting the iOS Simulator SDK via Terminal:

```bash
swiftc -parse -target arm64-apple-ios17.0-simulator \
  -sdk $(xcrun --sdk iphonesimulator --show-sdk-path) \
  Components/*.swift Models/*.swift Theme/*.swift ViewModels/*.swift \
  Views/Auth/*.swift Views/MapOS/*.swift Views/Onboarding/*.swift Views/Splash/*.swift \
  OrbitApp.swift
```

---

## 📋 Manual QA User Journey Validation Scripts

Follow these checklists to manually test the V1.0.0-RC1 user journey on iOS Simulator or physical test devices.

### Scenario 1: Initial Launch & Splash Transition
1. Launch the application.
2. Confirm the splash logo breathes with a glowing background.
3. Verify that a low-pass sound transition sweep plays when transitioning from the splash view.
4. Verify that the view automatically slides left to reveal the onboarding slides.

### Scenario 2: Biometric Passcode Authentication
1. Navigate past the onboarding tutorial to the passcode screen.
2. Type an incorrect passcode (anything other than `1997` or `1234`). Confirm the glass card shakes and a low-frequency alert tone plays.
3. Type the correct passcode (`1997`). Verify that the application transitions smoothly with a scale animation and opens the Map OS view.

### Scenario 3: Map-OS Layer Shifts & sound
1. Navigate the bottom glass tab bar:
   - Tap **[🏠 Home]**: Verify that the camera centers on the rotating spatial planet, displaying the Flight/Itinerary cards.
   - Tap **[📍 Tracker]**: Verify that the camera pans to Shibuya coordinates, tracking active friend nodes (e.g. Leo, Soras). Tapping a node should draw the path trail.
   - Tap **[🎨 Theme Settings]** inside the Group layer: Switch between Midnight Orbit and Tokyo Nights. Confirm that the background gradient changes and particle speeds accelerate/decelerate instantly.
2. Verify that high-frequency ticks play on each tab tap.

### Scenario 4: Geolocated Split Bills
1. Tap the **[📸 Memories]** tab.
2. Tap the segmented control selector: select **Expenses**.
3. Verify that neon orange expense pins (`💸`) appear on the Shibuya map canvas.
4. Tap an expense pin: verify that a glass drawer slides up, displaying the payer, category, total, and split amount for each friend.
5. Click the top-right HUD `+` button.
6. Input a title (e.g. `"Sake Night"`), amount (`300`), select a payer, and select the friends to split with.
7. Click **"Commit Split Bill"**.
8. Verify that the drawer closes, a sonar chime plays, and a new expense pin appears at Shibuya coordinates.
