# 📊 Analytics Architecture — Orbit (Chaos)

This document catalogs the analytical tracking specifications, schema structures, and telemetry guidelines for Orbit (Chaos).

---

## 🛡️ Telemetry & Privacy Philosophy

Orbit puts user privacy first:
1. **No Precise GPS Tracking**: Only general offset regions (e.g. city neighborhoods like Shibuya) are logged to aggregate trends.
2. **Pseudonymous Identifiers**: User analytics events use randomized UUID strings (`User.id`) rather than raw telephone numbers or names.
3. **No Third-Party Brokers**: Telemetry is dispatched to a self-hosted ingestion proxy before routing.

---

## 🎯 Tracked Milestones & Telemetry Payload Catalog

### 1. User Engagement & Retention

#### `session_start`
- **Trigger**: Booting the application from background.
- **Payload**:
  ```json
  {
    "device_model": "iPhone16,2",
    "os_version": "iOS 17.4",
    "active_theme": "Midnight Orbit",
    "network_type": "5G"
  }
  ```

#### `onboarding_complete`
- **Trigger**: Clicking the final "Enter Chaos" button on the onboarding tutorial scene.
- **Payload**:
  ```json
  {
    "time_spent_seconds": 42.6,
    "completed": true
  }
  ```

#### `authentication_success`
- **Trigger**: Correct pass-code input or face scan matching.
- **Payload**:
  ```json
  {
    "biometrics_used": true,
    "login_duration_ms": 150
  }
  ```

---

### 2. Social OS & Travel Activities

#### `memory_upload`
- **Trigger**: Committing a new geolocated memory node.
- **Payload**:
  ```json
  {
    "trip_id": "8BE999F9-F07F-4BFA-8E39-C462D6822AD1",
    "has_image": true,
    "coordinates_lat_offset": 0.0125,
    "coordinates_lon_offset": -0.0054
  }
  ```

#### `expense_logged`
- **Trigger**: Clicking "Commit Split Bill" and saving a shared bill pin.
- **Payload**:
  ```json
  {
    "amount": 240.0,
    "category": "Food",
    "splits_count": 3,
    "payer_is_me": true
  }
  ```

#### `chaos_spin_initiated`
- **Trigger**: Tapping the "Spontaneous Roulette" trigger.
- **Payload**:
  ```json
  {
    "anomaly_id": "9A88F110-3882-4EAD-B882-C2EF8228C91A",
    "selected_option": "Sing karaoke until dawn in Golden Gai",
    "spin_duration_seconds": 3.0
  }
  ```

#### `theme_switched`
- **Trigger**: Selecting a new styling skin in settings drawer.
- **Payload**:
  ```json
  {
    "previous_theme": "Midnight Orbit",
    "new_theme": "Tokyo Nights"
  }
  ```
