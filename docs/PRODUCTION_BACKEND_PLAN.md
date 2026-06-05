# 🖥️ Production Backend Plan — Orbit (Chaos)

This document details the transition plan from in-memory mock data to a production backend. It covers authentication, media storage, real-time synchronization, background location policies, offline storage, and conflict resolution.

---

## 🛠️ Backend Stack Architecture

We recommend a scalable serverless backend leveraging **Firebase / Cloud Firestore** and **Google Cloud Storage** (or a self-hosted **PostgreSQL / Supabase** cluster) to handle geolocation indices:

```
+-------------------------------------------------------------+
|                       Orbit iOS App                         |
+-------------------------------------------------------------+
               | (HTTPS / REST)           ^ (WebSockets)
               v                          |
+-----------------------------+  +----------------------------+
|        API Gateway          |  |    Realtime Sync Bus       |
|    (User auth, bills)       |  |  (Live location, reactions)|
+-----------------------------+  +----------------------------+
               |                          |
               +------------+-------------+
                            |
                            v
+-------------------------------------------------------------+
|                       Database Layer                        |
|        - Cloud Firestore (document store for settings)       |
|        - PostgreSQL (PostGIS extension for geo-queries)     |
+-------------------------------------------------------------+
```

---

## 📋 Module Specifications

### 1. Authentication (Cognito or Firebase Auth)
- **Production Spec**: Implement phone number authentication (via SMS OTP) using a secure verification gateway (e.g. Twilio).
- **Security**: Store JWT access tokens in the iOS Keychain. Invalidate tokens on logout.

### 2. Relational Database Schema & Geo-Queries
- To query nearby friends or geolocated memories, the database must support spatial indices.
- **Supabase/PostgreSQL with PostGIS**:
  ```sql
  CREATE TABLE geolocated_items (
      id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
      trip_id UUID NOT NULL,
      type VARCHAR(20) CHECK (type IN ('memory', 'expense', 'joke')),
      title VARCHAR(100) NOT NULL,
      coordinates GEOMETRY(Point, 4326) NOT NULL, -- Latitude/Longitude
      payload JSONB -- Contains splits, images, or captions
  );
  CREATE INDEX geo_items_spatial_idx ON geolocated_items USING GIST(coordinates);
  ```

### 3. Media & Storage Configuration
- **Storage**: Media is hosted on Google Cloud Storage or Amazon S3 bucket layers.
- **Optimization**: Images must be converted to **WebP** formats and compressed on the client side before uploading to minimize data transfer.

### 4. Live Synchronization & Signal Reactions
- **Live Location Trails**: Managed via WebSockets or Firebase real-time listeners. Location signals update every 5 seconds.
- **Ephemeral Reactions**: Dispatched over WebSockets as ephemeral payloads (no DB write) and cast directly to active group screens, keeping DB read/write costs low.

---

## 📡 Offline Behavior & Conflict Resolution

Orbit supports offline updates when users enter areas without cell coverage:

### Offline Storage (SwiftData / SQLite Cache)
- When offline, new memories, inside jokes, and expenses are written to a local SQLite cache.
- The queue is assigned a status of `pending_sync`.

### Conflict Resolution Strategy
- **Expenses & Balances**: If two users edit the same split bill concurrently, we use a **Last-Write-Wins (LWW)** resolution policy based on high-precision NTP synced client-side timestamps.
- **Location Trails**: Outdated coordinates are dropped; we only sync the latest location trail points.
- **Photos & Memories**: Uploads are appended sequentially based on the `createdAt` timestamp, preventing collisions.
