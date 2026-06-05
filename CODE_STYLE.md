# ✒️ Code Style Guide — Orbit (Chaos)

This document establishes the official coding standards, layout rules, and architectural style guidelines for writing clean, performant Swift and SwiftUI code in the Orbit project.

---

## 1. SwiftUI Declarative View Structure

To maintain clean and readable view files, structure all SwiftUI components using a consistent ordering:

```swift
struct MyComponent: View {
    // 1. Environment & EnvironmentObjects
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var appViewModel: AppViewModel
    
    // 2. Bindings & Parameter Inputs
    @Binding var isPresented: Bool
    let title: String
    
    // 3. State & StateObjects
    @State private var pulseScale: CGFloat = 1.0
    
    // 4. View Body
    var body: some Scene { ... }
}
```

### Layout Ordering Rules:
1. **No inline computation in body**: Heavy calculations (such as date formats or currency splits) should be extracted into computed variables or private helper methods.
2. **Modular sub-views**: Keep bodies under 150 lines. If a sub-view has its own complex state or state listeners, extract it into a dedicated component.
3. **Implicit Animations**: Avoid attaching general animations to parent views. Use explicit animations (`withAnimation(.spring(...))`) inside button actions to control transitions exactly.

---

## 2. Naming Conventions

* **Views**: Must end with `View` (e.g., `MapOSView`, `SplashScreenView`).
* **ViewModels**: Must end with `ViewModel` (e.g., `AppViewModel`).
* **Managers**: Must end with `Manager` (e.g., `SoundManager`, `ThemeManager`).
* **Models**: Use clear, singular nouns representing the data contract (e.g., `Expense`, `Memory`, `User`).
* **Variables**: CamelCase (e.g., `latOffset`, `currentUser`).

---

## 3. View Model and State Management

- Use `@StateObject` **only once** at the root instantiator (usually in `OrbitApp.swift`).
- Inject view models down the hierarchy using `.environmentObject(appViewModel)`.
- Use `@ObservedObject` only when a sub-component listens directly to a specific secondary data publisher.
- Keep the UI stateless where possible. SwiftUI views should be simple reflections of the states panned by `AppViewModel`.

---

## 4. Performance & Memory Guidelines

- **UUID Cleanup**: When creating arrays that trigger animations (e.g. signal reactions or emoji emitters), always implement an automated removal block inside a `DispatchQueue.main.asyncAfter` closure to purge the memory of expired models.
- **Backdrop Filters**: Use `.background(.ultraThinMaterial)` sparingly inside lists. Group backgrounds to avoid multiple overlapping glass layers, which causes GPU drawing thrashing.
- **Preferred Color Scheme**: The app uses `.preferredColorScheme(.dark)` globally. Do not set color schemes inside individual views to avoid override diagnostics.
