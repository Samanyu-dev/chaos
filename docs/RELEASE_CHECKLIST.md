# 🚦 V1.0.0-RC1 Release Checklist — Orbit (Chaos)

This checklist tracks final validation gates before submitting the V1 release candidate of Orbit to Apple for App Store review.

---

## 🛠️ Phase 1: Code and Compilation

- [ ] **Clean Compilation Check**: Execute terminal swift compilation test with zero diagnostic failures:
  ```bash
  swiftc -parse -target arm64-apple-ios17.0-simulator \
    -sdk $(xcrun --sdk iphonesimulator --show-sdk-path) \
    Components/*.swift Models/*.swift Theme/*.swift ViewModels/*.swift \
    Views/Auth/*.swift Views/MapOS/*.swift Views/Onboarding/*.swift Views/Splash/*.swift \
    OrbitApp.swift
  ```
- [ ] **Dependency Audit**: Confirm all SwiftUI views compile without requiring external CocoaPods or packages.
- [ ] **Dead Code & Asset Purge**: Verify no placeholder assets or diagnostic logs are active in release mode.

---

## 📲 Phase 2: User Journey & State Validation

- [ ] **Splash & Onboarding**: Transition from logo animations to the onboarding carousel displays without layout shifts.
- [ ] **Authentication Gate**: Lock screen biometric simulations reject incorrect passcodes and correctly authenticate with `1997`.
- [ ] **Map OS Engine Layering**: Camera pans and zooms to active pins. Reaction emoji particle emitters remove completed items to prevent memory leaks.
- [ ] **Shared Expenses geolocated pins**: Commit bill adds pins at offsets. Tap actions display details in the slide-up card.
- [ ] **Sound Manager Synth Check**: Unmuted audio plays PCM wave swoops, clicks, and chimes.

---

## 🏬 Phase 3: App Store Connect Prep

- [ ] **Metadata Assets**: Verify [APP_STORE_COPY.md](APP_STORE_COPY.md), [APP_STORE_KEYWORDS.md](APP_STORE_KEYWORDS.md), and long descriptions are uploaded.
- [ ] **App Review Support**: Confirm credentials are set in [APP_REVIEW_NOTES.md](APP_REVIEW_NOTES.md).
- [ ] **Legal Assets**: Check that [PRIVACY_POLICY.md](PRIVACY_POLICY.md) and [TERMS_OF_SERVICE.md](TERMS_OF_SERVICE.md) links are updated.
