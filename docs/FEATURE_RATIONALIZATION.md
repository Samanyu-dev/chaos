# ⚖️ Feature Rationalization Audit — Less But Better

This document details the visual and functional audit of Orbit (Chaos), identifying design noise, duplicate interactions, and structural simplifications that prioritize cognitive clarity.

---

## 🗂️ 1. Redundant View & Folder Cleanups

During the V1.0.0-RC1 transition, several legacy views and structures were pruned:

### ❌ MainTabView and HomeView (Legacy Tab Architecture)
- **Problem**: Previously, Orbit maintained a traditional TabView setup containing a static home dashboard and a map screen. This led to duplicate navigation buttons, high memory load from rendering multiple maps, and fragmented contexts.
- **Resolution**: **Deleted**. The entire interface has been unified under a single `MapOSView.swift` canvas. Switching layers now updates overlay filters rather than rebuilding tabs, reducing rendering overdraw.

### ❌ In-card Navigation Buttons
- **Problem**: Individual memory and expense cards previously contained independent navigation, directions, and profile links.
- **Resolution**: **Merged**. All interactions now leverage the bottom drawer cards. Tapping a marker centers the camera and opens a single, unified slider card, avoiding visual duplication.

---

## 🎨 2. Animation & Particle Optimization

To guarantee a minimum of 60 FPS (120 FPS on ProMotion) and reduce battery drain:

### Emitter Volume Caps
- **Problem**: The signal reaction emitter had unbounded particle generation limits, leading to potential rendering chokes.
- **Resolution**: Capped active reaction particle bounds to a maximum of 15 simultaneous items per user. Expired particles are removed from the array within $1.2\text{s}$ using UUID sweeps.

### Backdrop Blur Consolidation
- **Problem**: Layering multiple translucent `.ultraThinMaterial` panels over standard lists caused heavy CPU/GPU redraw thrashing.
- **Resolution**: Consolidated backgrounds. Sub-items (like split entries or text details) now use clean, solid semi-translucent colors (`Color.white.opacity(0.05)`) over a single underlying glass sheet, removing nested materials.

---

## 🧠 3. Cognitive Overload & Visual Cleanliness

We optimized information density to prevent cognitive fatigue:

| Component | Prototype State (Gimmicks) | Production V1 State (Rationalized) |
| :--- | :--- | :--- |
| **HUD Controls** | Scattered widgets, secondary settings button, floating widgets. | Single capsule HUD bar (Settings on left, Add Expense on right). |
| **Map Markers** | Complex cards floating over coordinates. | Simple emoji-themed pins with subtle neon circles. |
| **AI Guide (Orb)** | Continuously animated robotic overlay with constant speech bubbles. | Silent floating orb that only expands when clicked or during status shifts. |
| **Tab Filtration** | Standard tabs that completely replace screen viewports. | Floating translucent slider capsule showing active geographic layer. |
