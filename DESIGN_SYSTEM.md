# 🎨 Design System Guide — Orbit (Chaos)

This document catalogs the design system tokens, typography scales, glass material formulas, animation dynamics, and UI interactions that create the immersive visual aesthetic of Orbit (Chaos).

---

## 1. Typography Scale

Orbit uses iOS system fonts with custom weights and letter spacing, optimized for high legibility on dark glass backgrounds.

| Type Token | Font Size | Weight | Tracking (Letter Spacing) | Usage Example |
| :--- | :--- | :--- | :--- | :--- |
| **Hero Title** | 36pt | Heavy | -0.5pt | Splash logo, Onboarding headers |
| **Section Header** | 22pt | Bold | 0pt | Tab sheets, card headers |
| **Card Title** | 18pt | Semibold | +0.2pt | Memory overlays, expense payers |
| **Primary Body** | 15pt | Regular | 0pt | Drawer descriptions, inside joke text |
| **Detail Label** | 12pt | Medium | +0.5pt | Pinned timestamps, splitter amounts |

---

## 2. Spacing Scale

Orbit enforces a strict 8pt layout grid:

- **`8pt` (XS)**: Inner card padding, avatar borders.
- **`16pt` (S)**: Standard card padding, item margins.
- **`24pt` (M)**: Global grid margins, gap between cards.
- **`32pt` (L)**: Drawer headers offset, spatial home planet spacing.
- **`48pt` (XL)**: Bottom glass tab bar viewport overlay offset.

---

## 3. Glassmorphic Materials & Blur Formulas

The "Glassmorphic" depth effect is achieved through overlaying translucent colors, blurs, and borders:

```
+--------------------------------------------------------------+
|                1. Backdrop Blur (.ultraThinMaterial)          |
+--------------------------------------------------------------+
                               |
                               v
+--------------------------------------------------------------+
|      2. Inner Translucent Layer (.white.opacity(0.05))       |
+--------------------------------------------------------------+
                               |
                               v
+--------------------------------------------------------------+
|     3. High-Contrast Border (.white.opacity(0.08 / 0.15))    |
+--------------------------------------------------------------+
```

### Swift Implementation Code:
```swift
struct GlassBackground: ViewModifier {
    var theme: OrbitTheme
    
    func body(content: Content) -> some View {
        content
            .background(theme.cardBackground)
            .background(.ultraThinMaterial)
            .cornerRadius(24)
            .overlay(
                RoundedRectangle(cornerRadius: 24)
                    .stroke(theme.cardBorder, lineWidth: 1)
            )
            .shadow(color: theme.ambientGlow.opacity(0.2), radius: 12, x: 0, y: 8)
    }
}
```

---

## 4. Visual Themes & Colors

We maintain six curated themes inside `Theme/Theme.swift`:
1. **Midnight Orbit** (`#080810` / Blue / Purple) - Default celestial theme.
2. **Neon Nightlife** (`#05020c` / Neon Red / Pink) - Cyber vibes.
3. **Sunset Drive** (`#120b08` / Gold / Orange) - Warm, emotional.
4. **Arctic Minimal** (`#0f1215` / Silver-Blue / Frost) - Quiet, clean.
5. **Cyber Glow** (`#000508` / Teal / Violet) - Deep contrast glow.
6. **Tokyo Nights** (`#0b0816` / Magenta / Cyber Purple) - Tokyo Shibuya nightlife.

---

## 5. Motion & Interaction Dynamics

Transitions should feel kinetic, spring-loaded, and responsive.

### Standard Spring Presets:
- **Snappy Switch (`activeTab` changes)**:
  `Animation.spring(response: 0.35, dampingFraction: 0.72)`
- **Drawer Slide-up**:
  `Animation.spring(response: 0.45, dampingFraction: 0.82)`
- **Chaos Roulette deceleration**:
  `Animation.spring(response: 0.6, dampingFraction: 0.7)`

### Custom Button Press (Haptics):
Interactive items must use `HapticButtonStyle` (`Components/BreathingButton.swift`) which scales the button to `0.94` on press and triggers a physical tactile tick using `UIImpactFeedbackGenerator`.
