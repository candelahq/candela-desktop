# 🕯️ Candela Desktop

Native macOS desktop app for [Candela](https://github.com/candelahq/candela) — the OTel-native LLM observability platform. Built with Flutter.

## Install

```bash
brew install --cask candelahq/tap/candela-desktop
```

Or download the latest `.dmg` from [GitHub Releases](https://github.com/candelahq/candela-desktop/releases).

## Features

- **Provider Dashboard** — connect and monitor OpenAI, Google Gemini, Anthropic (Vertex), Ollama, vLLM, and LM Studio
- **Traces Screen** — searchable, filterable span list with sortable columns, expandable detail rows, latency visualization
- **Models Screen** — model catalog with per-model stats, cost analysis, efficiency metrics (cost/call, tokens/call, output ratio)
- **Settings Screen** — theme switcher, launch-at-login, proxy port config, mode switcher, version info
- **Config Editor** — live YAML editor for `~/.config/candela/config.yaml` with validation
- **Mode Switcher** — toggle between Solo, Solo + Cloud, and Team modes
- **Auto-Start Proxy** — automatically starts the `candela` CLI proxy on launch if installed but not running
- **CLI Management** — detects missing CLI, offers one-click `brew install`, and shows upgrade banners when newer versions are available
- **Self-Update** — upgrade the desktop app via `brew upgrade --cask` from the system tray menu
- **Dark/Light Mode** — full light and dark themes with system preference detection
- **Secure Storage** — API keys stored in macOS Keychain

## CLI Integration

Candela Desktop works best alongside the [`candela` CLI](https://github.com/candelahq/candela):

```bash
brew install candelahq/tap/candela
```

The desktop app auto-detects the CLI and provides:
- One-click install if `candela` is not found
- Upgrade banners when a newer version is available
- Auto-start of the proxy on app launch

## Development

```bash
git clone https://github.com/candelahq/candela-desktop.git
cd candela-desktop
flutter pub get
flutter run -d macos
```

### Testing

```bash
flutter test                    # unit + widget tests (~550 tests)
flutter analyze                 # static analysis
```

## License

Apache-2.0 — see [LICENSE](LICENSE).
