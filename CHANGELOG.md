# Changelog

All notable changes to Candela Desktop are documented here.

## v0.5.3 — 2026-05-27

### Fixes
- fix: skip `vertex_ai.project` and `vertex_ai.region` validation in team mode — the remote server provides GCP credentials, so these are not required locally

---

## v0.5.2 — 2026-05-25

### Fixes
- fix: wire up update button and fix model breakdown duplicates/cap (#85)
- fix: await `performBrewUpgrade` and show error on failure
- style: set explicit text color on update snackbar

---

## v0.5.1 — 2026-05-25

### Auth Stability
- fix: guard token refresh against stale state after Team→Solo mode switch (#84)
- fix: `_candelaAuth` null-promotion and persist in `configure()` (#83)

### Docs
- Update architecture docs for DashboardController, CandelaAuthService, and test count

---

## v0.5.0 — 2026-05-20

### Riverpod 3.x Migration (#80, #81)
- Migrate `DashboardController` and `DashboardNotifier` to Riverpod 3.x Notifier pattern

### Features
- Dynamic `UserScope` toggle for admin dashboard views (#79)
- Model pricing columns and cache efficiency badges (#77)

### Refactoring
- Replace `gcloud` CLI dependency with native `CandelaAuthService` (#78)
