# 🚀 Release Process & Deployment Guide — Orbit (Chaos)

This guide details the release pipelines, Xcode provisioning requirements, and TestFlight deployment procedures to push Orbit (Chaos) to the App Store.

---

## 🔑 1. Xcode Provisioning & Signing Configuration

To compile and submit Orbit to App Store Connect, configure Apple Developer signing in Xcode:

1. **Team Identifier**: Select your Apple Developer account under the Target Signing & Capabilities pane.
2. **Bundle Identifier**: `social.chaos.orbit`
3. **Provisioning Profiles**: Set Xcode Signing to **Automatically manage signing**.
4. **Required Capabilities**:
   - Background Modes (Location updates, Remote notifications)
   - Push Notifications (APNs)
   - iCloud (CloudKit for data syncing in V2)

---

## 📦 2. Distributing to TestFlight (Beta Release)

We release weekly builds to external and internal beta testers using Apple TestFlight.

### Deployment Workflow:
1. **Version Control Check**: Ensure all features compile cleanly under `swiftc`.
2. **Bump Build Number**: Increment the build version under Xcode Project Settings (e.g. Version `1.0.0`, Build `1`).
3. **Archive Build**:
   - In Xcode menu, select **Product > Archive**.
   - Select **Any iOS Device (arm64)** as target.
4. **Upload to Apple**:
   - In Organizer, select the compiled archive and click **Distribute App**.
   - Select **TestFlight & App Store** distribution.
   - Complete the prompts to sign with your developer certificate and upload.
5. **Add TestFlight Notes**: Fill out testing guidelines as documented in [TESTFLIGHT_GUIDE.md](docs/TESTFLIGHT_GUIDE.md).

---

## 🚦 3. Final Production Release Gates

Before clicking the release button in App Store Connect, ensure the following steps are verified:
- [ ] Automated compilation is validated.
- [ ] No force unwraps exist in ViewModel data loaders.
- [ ] All mock drawers transition without layout thrashing.
- [ ] App Review notes and test accounts are configured as detailed in [APP_REVIEW_NOTES.md](docs/APP_REVIEW_NOTES.md).
