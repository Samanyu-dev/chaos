# 🕵️ Apple Review Audit — Guidelines Compliance Checklist

This document audits Orbit (Chaos) against Apple's official App Review Guidelines prior to App Store submission.

---

## 📋 1. Core Guidelines Compliance Audit

### 📍 Guideline 2.5.4 — Multitasking & Background Location Services
- **Audit Requirement**: Background location usage must be justified.
- **Compliance Status**: **Pass**. Orbit uses background location updates to render friend tracks on Shibuya coordinates. The app includes fallbacks when location permissions are denied.
- **Action Item**: Add the required usage description key to `Info.plist`:
  `NSLocationWhenInUseUsageDescription` and `NSLocationAlwaysAndWhenInUseUsageDescription`.

### 🖼️ Guideline 5.1.1 — Data Collection & Privacy
- **Audit Requirement**: Apps collecting user photos or camera buffers must explain usage.
- **Compliance Status**: **Pass**. Uploading photos is restricted to geolocated memory pins within a closed group space. We do not use user photos for advertising.
- **Action Item**: Add camera and photo library usage descriptions to `Info.plist`:
  `NSCameraUsageDescription` and `NSPhotoLibraryUsageDescription`.

### 👥 Guideline 1.2 — Safety & User-Generated Content (UGC)
- **Audit Requirement**: Apps hosting user-submitted content must provide moderation tools.
- **Compliance Status**: **Pass**. Users can delete their posted memories and inside joke pins at any time.
- **Action Item**: Implement a "Block/Report User" button in user profiles to meet Apple's UGC safety requirements before submitting.

---

## 🔒 2. Privacy Manifests (`PrivacyInfo.xcprivacy`)

To comply with Apple's privacy manifest requirements, we declare our data collection purposes:

| API Declared | Reason Category | Usage Description |
| :--- | :--- | :--- |
| **`NSPosition`** | Location offsets | Simulating relative coordinates to display friend pins on the group map. |
| **`NSCamera`** | Camera Capture | Capturing photos for memories pinned to location coordinates. |
| **`NSUserDefaults`** | Local Storage | Storing the active visual theme selection (`themeManager`). |

---

## 🚦 3. Required App Review Information

- **Test Account Setup**: Create a test group containing sample memory and joke coordinates to show the reviewer.
- **Reviewer Note**: Reviewers must use the demo passcode `1997` on the lock screen to unlock the Map OS layers.
- **Audio synthesis note**: Inform reviewers that the app synthesizes sound waves in real-time, requiring unmuted speakers to test.
