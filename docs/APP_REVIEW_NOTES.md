# 🕵️ App Review Notes — Orbit (Chaos)

Dear App Review Team,

Orbit (Chaos) is a spatial social operating system for close friends traveling together. The application utilizes a customized **Map-as-an-OS** shell to integrate real-time tracking, memory logging, and split bill management over a central Shibuya Map Canvas.

---

## 🔑 Demo Account Credentials & Auth Verification

The app enforces a futuristic passcode lock screen during onboarding. Please use the following details to bypass this gate:

- **Passcode to authenticate**: `1997`
- **Alternative passcode**: `1234`
- Enter the code on the glowing glass keypad to instantly load the core Map OS layer.

---

## 🗺️ How to Verify Key Features

Once authenticated, you will be placed directly onto the living Shibuya Map Canvas. Follow these instructions to review core features:

### 1. Unified Map OS & Friend Positions
- Tap the **[📍 Tracker]** button on the bottom tab deck.
- You will see geolocated friend markers. Tap an avatar to see their current trail path.
- Tap **[🏠 Home]** to return the camera to the main floating Trip Planet.

### 2. Geolocated Split Bills
- Tap the **[📸 Memories]** tab.
- Click the segmented control selector and select **Expenses**.
- Tap any orange expense pin (`💸`) mapped on the Shibuya canvas. A slide-up card will display splitting details.
- Tap the `+` button in the top HUD. Log an expense and click **"Commit Split Bill"**. A new pin will appear at Shibuya offsets.

### 3. Ambient PCM Sound Engine
- Orbit synthesizes custom PCM waves dynamically for ticks, swipes, and sonar chimes. Please ensure your test device is **unmuted** to review audio feedback.

---

## 🛰️ Location Tracking Explanation
Orbit tracks coordinate offsets relative to the trip's center (Shibuya). This background tracking runs in low-power mode to draw friend trails and notify users of proximity. We request background location access for this purpose.
- **Privacy Assurance**: Location signals are mapped to offsets and cleared when the user leaves the group space.
