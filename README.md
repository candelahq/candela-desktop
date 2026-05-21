# 🕯️ Candela Desktop

Native macOS desktop app for [Candela](https://github.com/candelahq/candela) — the OTel-native LLM observability platform. Built with Flutter.

[![CI](https://github.com/candelahq/candela-desktop/actions/workflows/ci.yml/badge.svg)](https://github.com/candelahq/candela-desktop/actions/workflows/ci.yml)
[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](LICENSE)

## Install

```bash
# macOS (Apple Silicon — runs via Rosetta 2 on Intel)
brew install --cask candelahq/tap/candela-desktop
```

Or download the latest `.dmg` from [GitHub Releases](https://github.com/candelahq/candela-desktop/releases).

> **Requires `candela` CLI v0.3.3+** for the consolidated dashboard RPC. Install with:
> ```bash
> brew install candelahq/tap/candela
> ```

---

## Features

### 🖥️ Dashboard
- **Consolidated data fetch** — a single `GetDashboardData` RPC retrieves usage, budget, grants, and cache telemetry atomically
- **Today view** — real-time spend vs. daily budget with grant-first waterfall display
- **Time-series charts** — token and cost trends with model breakdown
- **Visibility-aware polling** — pauses background refreshes when app is backgrounded (60s interval, 50s client-side TTL cache)

### 💰 Budget & Grants
- Daily budget progress with color-coded urgency (green → yellow → red)
- Active grant list with individual remaining amounts and reset countdowns
- Team-mode: per-user usage attribution and leaderboard

### 🔍 Traces
- Searchable, filterable span list with sortable columns
- Expandable detail rows with full prompt/completion, token counts, latency, and cost
- Latency visualization per span

### 📊 Models
- Per-model stats: cost/call, tokens/call, output ratio, efficiency metrics
- Cache hit rates and cache cost breakdown (Anthropic write vs. read pricing)

### ⚙️ Settings
- **Prompt caching controls** — toggle Anthropic cache TTL (5m default, 1h for long coding sessions)
- **Mode switcher** — Solo, Solo + Cloud, Team
- Config YAML editor for `~/.config/candela/config.yaml` with live validation
- Theme switcher (light/dark/system), launch-at-login, proxy port config

### 🔐 Authentication
- Native OAuth2 via `candela auth login` — no `gcloud` CLI dependency
- ADC credential status with real expiry display (not a hardcoded 15-min fallback)
- Direct token refresh against Google's token endpoint

### 🔄 Auto-Update & CLI Management
- Detects missing `candela` CLI and offers one-click `brew install`
- Shows upgrade banners when a newer CLI version is available
- Self-update via `brew upgrade --cask` from system tray menu

### 🎨 UX
- Full dark and light themes with system preference detection
- API keys stored in macOS Keychain

---

## CLI Integration

Candela Desktop requires the [`candela` CLI](https://github.com/candelahq/candela) running as a local proxy:

```bash
brew install candelahq/tap/candela
candela start          # background daemon on :8181
candela status         # check running state
```

The desktop app auto-detects the CLI on startup, starts it if needed, and shows install/upgrade prompts if missing or outdated.

---

## Development

### Prerequisites

- Flutter 3.x / Dart 3.x (via `nix develop` or manual install)
- macOS (desktop target only)
- `candela` CLI running locally for full feature testing

### Setup

```bash
git clone https://github.com/candelahq/candela-desktop.git
cd candela-desktop

# With Nix (recommended — pins Flutter + Dart versions)
nix develop
flutter pub get
flutter run -d macos

# Without Nix
flutter pub get
flutter run -d macos
```

### Proto Generation

Proto stubs are generated from [candelahq/candela-protos](https://github.com/candelahq/candela-protos) via BSR:

```bash
buf generate   # requires buf + BUF_TOKEN
```

### Testing

```bash
flutter test                     # unit + widget tests (~855 tests)
flutter test integration_test/   # E2E integration tests (requires macOS runner)
flutter analyze                  # static analysis + lint
```

The integration test suite covers: app boot, dashboard empty state, onboarding flow, navigation, and settings screen.

---

## Architecture

- **State management**: [Riverpod 3.x](https://riverpod.dev) with code-gen (`@riverpod`)
- **RPC**: ConnectRPC via generated Dart stubs from BSR
- **Key provider**: `DashboardController` — class-based Riverpod Notifier with reactive polling, immutable state snapshots (`copyWith`), and disposal guards; drives all screens and eliminates redundant per-screen fetches
- **Auth**: Native ADC (`CandelaAuthService`) reads the ADC credentials file and refreshes tokens directly against `oauth2.googleapis.com` — no gcloud CLI dependency

---

## License

Apache-2.0 — see [LICENSE](LICENSE).
