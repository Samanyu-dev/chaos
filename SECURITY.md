# 🛡️ Security Policy — Orbit (Chaos)

We take the security and privacy of our users' travel memories, expense histories, and location coordinates very seriously. Please review this document to understand our security standards.

---

## 🔒 1. Sandbox Isolation

Orbit strictly operates within the sandbox environment provided by iOS:
- **File System**: Local storage is isolated to the application's **Documents Directory**. The app cannot read or write files outside this sandbox.
- **Biometrics**: Passcode checks and face scans are validated locally via Apple's **LocalAuthentication** framework. User credentials are not transmitted across the network.
- **Keychain**: API tokens (scheduled for V1.1.0 backend integration) are stored securely in the iOS System Keychain using AES-256 encryption.

---

## 📨 2. Reporting Vulnerabilities

If you discover a security vulnerability, please report it immediately:
- **Email**: security@chaos.social
- **Response SLA**: The security triage team will respond to reports within **48 hours**.
- Please do not open public GitHub issues for security reports.
