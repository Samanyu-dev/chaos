# 🗺️ Phased Integration Plan — Orbit (Chaos)

This document establishes the roadmap to translate Orbit from its current compiled prototype state into the fully productized architecture defined in your 7-phase plan. It details **how to configure each phase**, lists the **exact inputs required from your side**, and defines our **free-of-cost AI strategy**.

---

## 🧠 Free-of-Cost AI Architecture (Replacing Claude)

To completely eliminate API usage costs, we replace the proposed Claude integration with two free, production-ready solutions:

### Option A: Google Gemini API Free Tier (Recommended for Cloud Tasks)
Google AI Studio offers a **free-of-charge tier** for the **Gemini 1.5 Flash** model (up to 15 Requests Per Minute, 1,500 Requests Per Day). This provides advanced cloud intelligence at zero cost.
- **Usage**: Generating dynamic itinerary details, conversing with the `FloatingOrbGuide`, and analyzing complex expenses.
- **Swift Integration**:
  ```swift
  import GoogleGenerativeAI
  
  let model = GenerativeModel(name: "gemini-1.5-flash", apiKey: "YOUR_FREE_GEMINI_API_KEY")
  let response = try await model.generateContent("Suggest 3 hidden vinyl records spots in Shibuya.")
  ```

### Option B: Apple Native On-Device Frameworks (Best for Local Privacy & Offline)
Leverage Apple's built-in frameworks, which execute locally on the device with zero network overhead, zero latency, and zero cost:
- **Smart Expense Categorization**: Use Apple’s native **`NaturalLanguage`** framework to categorize transaction descriptions using on-device text classification:
  ```swift
  import NaturalLanguage
  
  let tags = NLTagger(tagSchemes: [.lexicalClass])
  tags.string = "Shibuya Ramen Fuel bill"
  // On-device classification maps "Ramen" to "Food" category
  ```
- **Voice Message Transcription**: Use Apple's native **`Speech`** framework (`SFSpeechRecognizer`) for free local transcription of audio memory notes.
- **Itinerary Parsing**: Use standard local regex rules engines combined with JSON parsing to extract trip schedules without LLM processing.

---

## 📂 Phase-by-Phase Integration Audit & User Actions

---

### Phase 1 · Foundation & Architecture

- **Current Prototype State**: Buildable SwiftUI codebase using in-memory `MockData` states and simulated offsets.
- **Production Code Changes**:
  - Restructure project into modular frameworks: `Core`, `Design`, `Features`, and `Networking` targets.
  - Install Supabase Swift SDK via Swift Package Manager (SPM).
- **User Inputs Needed**:
  1. **Supabase URL & Anon Key**: Connects backend DB and Auth interfaces.
  2. **Apple Developer Account (Paid/Free)**: Sets up Apple Sign-in capabilities and provisioning portals.
- **How to Get Them**:
  - *Supabase*: Create a free account at [supabase.com](https://supabase.com), create a new project, and copy the URL and API Anon Key from **Project Settings > API**.
  - *Apple Developer*: Register at [developer.apple.com](https://developer.apple.com). In Xcode, navigate to **Settings > Accounts** and log in with your Apple ID to enable automatic signing.

---

### Phase 2 · Visual Identity & Design System

- **Current Prototype State**: Implemented 6 enums-based visual theme managers, breathing scale buttons, and basic onboarding transitions.
- **Production Code Changes**:
  - Draw custom star constellations on canvas coordinates for lock authentication.
  - Hashing pattern paths using Apple's `CryptoKit` framework.
- **User Inputs Needed**:
  1. **Tripo AI API Key**: To generate the 3D orbital sphere logo, astronaut companion, and trip terrain variations.
  2. **Figma Logo Assets**: SVG vectors for App Store icon sizes.
- **How to Get Them**:
  - *Tripo AI*: Create a developer profile at [tripo3d.ai](https://www.tripo3d.ai) to claim free API credits. Copy your API Key from your dashboard.
  - *Figma*: Open your design canvas, select your flattened orbital sphere icon, and click **Export > SVG**.

---

### Phase 3 · Core UX Screens

- **Current Prototype State**: Single-canvas ZStack map canvas with dragging offsets, bottom memory details cards, and simulated roulette spinners.
- **Production Code Changes**:
  - RealityKit loading of the astronaut companion rigged skeleton.
  - SceneKit physics integration for the 3D rotating Chaos roulette disc.
  - ActivityKit Live Activity implementation for Dynamic Island layouts.
- **User Inputs Needed**:
  1. **USDZ 3D Models**: The companion astronaut and spinning roulette disc models (generated in Phase 2).
- **How to Get Them**:
  - Run the Tripo AI generation pipeline using your key, download the resulting `.usdz` assets, and drag them directly into the Xcode project bundle.

---

### Phase 4 · Backend, Database & Realtime

- **Current Prototype State**: State arrays in `AppViewModel` handle logins, memory uploads, and expense additions locally.
- **Production Code Changes**:
  - Create PostgreSQL tables (`profiles`, `trips`, `expenses`, `memories`) with Row Level Security (RLS) policies.
  - Set up Supabase Realtime Presence listeners to broadcast location offsets.
- **User Inputs Needed**:
  1. **APNs Authentication Key (`.p8` file)**: Required to send push notifications.
- **How to Get Them**:
  - Go to [developer.apple.com](https://developer.apple.com), select **Certificates, Identifiers & Profiles > Keys**, create a new key, enable Apple Push Notifications service (APNs), and download the `.p8` file.

---

### Phase 5 · Social Features & AI Integration

- **Current Prototype State**: Simulated emoji signal reaction streams and simulated post-memory drawers.
- **Production Code Changes**:
  - Integrate Gemini API Free SDK (or Apple's local `NaturalLanguage` classes).
  - Voice transcription logic using iOS `AVAudioRecorder` and local `SFSpeechRecognizer` targets.
- **User Inputs Needed**:
  1. **Gemini API Key**: Required for Cloud-based AI suggestion features.
- **How to Get Them**:
  - Go to [aistudio.google.com](https://aistudio.google.com), click **Get API Key**, create a new key in a Google Cloud project, and copy the key.

---

### Phase 6 · Polish, 3D Models & Performance

- **Current Prototype State**: Emitters remove reaction elements after $1.2\text{s}$ to prevent leaks.
- **Production Code Changes**:
  - Audit thread hitches using Xcode Instruments Profiler to ensure steady 60/120 FPS runs.
  - Accessibility labels validation on custom interactive cards.
- **User Inputs Needed**:
  1. **Device for Profiling**: A physical iPhone supporting ProMotion (iPhone 13 Pro or newer) to record real frame-rate performance.
- **How to Get Them**:
  - Connect your physical iPhone to Xcode via USB and select it as the build target run destination.

---

### Phase 7 · Launch Preparation & App Store Connect

- **Current Prototype State**: Fully compiled and documented build V1.0.0-RC1.
- **Production Code Changes**:
  - Integrate PostHog SDK for analytics and Sentry SDK for error logging.
  - StoreKit 2 configuration for subscription gates.
- **User Inputs Needed**:
  1. **PostHog Project API Key** & **Sentry DSN URL**.
  2. **App Store Connect Credentials**.
- **How to Get Them**:
  - Create free-tier accounts at [posthog.com](https://posthog.com) and [sentry.io](https://sentry.io) and copy the project keys.
  - Log in at [appstoreconnect.apple.com](https://appstoreconnect.apple.com) to initialize your app listing.
