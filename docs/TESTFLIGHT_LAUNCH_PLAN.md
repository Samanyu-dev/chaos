# ✈️ TestFlight Launch Plan — Build Distribution

This document details the configuration and release steps to distribute the Orbit (Chaos) V1.0.0-RC1 build to external and internal beta testers on TestFlight.

---

## 🛠️ 1. Production Build Configuration

To deploy the candidate build, Xcode schemas are configured as follows:

- **Build Scheme**: Release
- **Compilation optimization**: Fast, Small (`-O`)
- **Debug Information Format**: DWARF with dSYM File (required for crash log symbolication)
- **Active Compilation Conditions**: `RELEASE`, `ANALYTICS_ENABLED`, `LOGGING_ENABLED`

---

## 📊 2. Crash Diagnostics & Telemetry

We integrate self-hosted logging and crash monitoring parameters to trace device behaviors:

### Unified Console Logging (OSLog)
To capture logs without leaking private data, we initialize `OSLog` channels in Swift:
```swift
import OSLog

extension Logger {
    private static var subsystem = Bundle.main.bundleIdentifier!
    static let ui = Logger(subsystem: subsystem, category: "UI")
    static let sound = Logger(subsystem: subsystem, category: "Sound")
    static let analytics = Logger(subsystem: subsystem, category: "Analytics")
}
```

### Crash Detection (Crashlytics SDK integration plan)
- Captures unhandled exceptions and SIGSEGV memory faults.
- Automatically uploads dSYM symbols to map memory address offsets to file and line numbers.

---

## 📝 3. TestFlight Release Notes

Copy and paste this text into the **What to Test** field in App Store Connect:

```txt
Welcome to the Orbit (Chaos) V1.0.0-RC1 release! 

Please focus your testing on our new Map-as-an-OS unified interface:
1. Complete the onboarding passcode flow (use code 1997 to unlock).
2. Navigate the bottom tab layers (Home, Tracker, Memories, Chaos, Group).
3. Tap the Memories tab, switch the segment to Expenses, and click geolocated bills pins to review splits.
4. Click the top-right '+' HUD button to commit a new geolocated split bill.
5. In the Group space settings drawer, toggle color themes and verify that background particles adapt.
6. Ensure your speakers are unmuted to experience synthesized UI ticks, sweeps, and sonar chimes.

Report crashes or alignment bugs directly through the TestFlight feedback screen.
```
