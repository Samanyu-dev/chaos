# 📊 Analytics Verification Checklist

This document maps out event triggers, payload structures, and assertion scripts to verify that telemetry metrics are dispatched correctly during user sessions.

---

## 🎯 Telemetry Verification Matrix

| Tracked Milestone | Code Trigger Location | Verification Method / Console Assertion |
| :--- | :--- | :--- |
| **onboarding_complete** | `OnboardingView.swift:534` | Assert `appState` transitions to `.auth`. Logs: `[Analytics] Dispatched: onboarding_complete` |
| **signup_complete** | `AuthView.swift:145` | Verify `appState` switches to `.mainTab`. Logs: `[Analytics] Dispatched: signup_complete` |
| **group_created** | `AppViewModel.swift:115` | Assert a new user group structure initializes. Logs: `[Analytics] Dispatched: group_created` |
| **trip_created** | `AppViewModel.swift:128` | Assert `trips.count` increments by 1. Logs: `[Analytics] Dispatched: trip_created` |
| **invite_sent** | `MapOSView.swift:590` | Confirm recipient user UUID passes. Logs: `[Analytics] Dispatched: invite_sent` |
| **invite_accepted** | `AppViewModel.swift:110` | Assert new `User` is appended to `friends` array. Logs: `[Analytics] Dispatched: invite_accepted` |
| **memory_created** | `AppViewModel.swift:131` | Assert `memories.insert` adds item. Logs: `[Analytics] Dispatched: memory_created` |
| **expense_created** | `AppViewModel.swift:92` | Assert `expenses.insert` adds item. Logs: `[Analytics] Dispatched: expense_created` |
| **chaos_spin** | `AppViewModel.swift:96` | Assert `isChaosSpinning` toggles true -> false. Logs: `[Analytics] Dispatched: chaos_spin` |
| **theme_change** | `ThemeManager.swift` | Assert `activeTheme` rawValue changes. Logs: `[Analytics] Dispatched: theme_change` |
| **session_duration** | `OrbitApp.swift` | Capture timestamp delta on backgrounding. Logs: `[Analytics] Dispatched: session_duration` |
| **return_session** | `OrbitApp.swift` | Triggered when active session resumes. Logs: `[Analytics] Dispatched: return_session` |

---

## 💻 Console Verification Command

To verify that analytics events log cleanly to the diagnostic stream during local simulator testing:

1. Launch Orbit in Xcode.
2. Filter the Debug Console log stream using the following grep check:
   ```bash
   # Filter system logs for telemetry dispatches
   log show --style syslog --predicate 'subsystem == "social.chaos.orbit" AND category == "Analytics"'
   ```
3. Perform the onboarding flow, enter passcode `1997`, log a test expense, and verify that the logs display corresponding events without diagnostics failures.
