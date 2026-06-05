# 🤝 Contributing to Orbit (Chaos)

We are thrilled that you want to contribute to Orbit (Chaos)! To maintain startup-grade engineering practices, please read and follow this guide before making any changes.

---

## 💻 Developer Setup Checklist

1. **Clone the Repository**:
   ```bash
   git clone https://github.com/chaos-social/orbit-ios.git
   cd orbit-ios
   ```
2. **Open the Project**:
   - Double-click `chaos.xcodeproj` or open the root directory directly in Xcode 15+.
3. **Select active target**:
   - Set target scheme to `Orbit` and select the latest iOS Simulator.
4. **Run compilation check**:
   - Press `Cmd + B` to ensure the project compiles out-of-the-box.

---

## 🌿 Git Branching Workflow

We follow a strict release-branching strategy to ensure that the main branch remains stable and release-ready.

- **`main`**: Production-ready code. No direct commits are allowed.
- **`dev`**: Integration branch for pre-release features.
- **`feature/feature-name`**: Short-lived branches dedicated to building single modules or fixing issues.

### Branch Lifecycle Example
1. Create a branch from `dev`:
   ```bash
   git checkout -b feature/map-expenses
   ```
2. Write clean code, following the guidelines in [CODE_STYLE.md](CODE_STYLE.md).
3. Verify compilation and run test scripts:
   ```bash
   swiftc -parse Models/*.swift ViewModels/*.swift Theme/*.swift
   ```
4. Commit your changes with descriptive titles:
   ```bash
   git commit -m "feat(map): render geolocated expense pins on Shibuya grid"
   ```
5. Push to remote and open a Pull Request targeting the `dev` branch.

---

## 📋 Pull Request Requirements

Before a PR can be reviewed and merged, it must meet the following criteria:

- [ ] **Compiles cleanly**: Zero compilation errors or diagnostic warnings.
- [ ] **Audio/Visual alignment**: Animations must follow the timing scales in [DESIGN_SYSTEM.md](DESIGN_SYSTEM.md) and execute at a minimum of 60 FPS (120 FPS on ProMotion).
- [ ] **Code Formatting**: Order struct declarations as outlined in [CODE_STYLE.md](CODE_STYLE.md).
- [ ] **Documentation**: Any model modifications must be documented in [API_DOCUMENTATION.md](API_DOCUMENTATION.md).

---

## 🛠️ Sandbox Safety Rules

Orbit does not write files to directories outside of its designated sandbox workspace. Never propose or execute commands targeting directories outside of the workspace environment (e.g. `/tmp`, `/home`, or desktop roots).
All temporary test outputs must be saved inside the `<workspace>/docs/` or `.gemini` folders.
