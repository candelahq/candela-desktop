{
  description = "Candela Desktop — Flutter development environment";

  inputs = {
    flake-schemas.url = "https://flakehub.com/f/DeterminateSystems/flake-schemas/*";
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs = { self, flake-schemas, nixpkgs }:
    let
      supportedSystems = [ "x86_64-linux" "aarch64-darwin" "x86_64-darwin" "aarch64-linux" ];
      forEachSupportedSystem = f: nixpkgs.lib.genAttrs supportedSystems (system: f {
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
      });
    in {
      schemas = flake-schemas.schemas;

      devShells = forEachSupportedSystem ({ pkgs }: {
        default = pkgs.mkShell {
          packages = with pkgs; [
            # ── Flutter / Dart SDK ──────────────────────────────
            flutter              # Flutter stable (includes Dart SDK)

            # ── macOS native build tooling ─────────────────────
            cocoapods            # CocoaPods for macOS Runner dependencies

            # ── General dev tooling ────────────────────────────
            git
            gh                   # GitHub CLI (PRs, issues, etc.)
            lefthook
            jq                   # handy for JSON config inspection
          ];

          shellHook = ''
            echo ""
            echo "🕯️  Candela Desktop dev shell"
            echo "   Flutter : $(flutter --version --machine 2>/dev/null | jq -r '.frameworkVersion // "checking..."')"
            echo "   Dart    : $(dart --version 2>&1 | head -1)"
            echo ""

            # CocoaPods requires UTF-8
            export LANG=''${LANG:-en_US.UTF-8}

            # Disable Flutter analytics in CI / dev shells
            export FLUTTER_SUPPRESS_ANALYTICS=true

            # Let Flutter know we manage the SDK externally
            export FLUTTER_ROOT="$(dirname $(dirname $(which flutter)))"

            # Install lefthook git hooks (only if not already present)
            if ! grep -q 'LEFTHOOK' .git/hooks/pre-commit 2>/dev/null; then
              lefthook install 2>/dev/null
            fi
          '';
        };
      });
    };
}
