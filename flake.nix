{
  description = "Candela Desktop — Flutter development environment + binary install";

  inputs = {
    flake-schemas.url = "https://flakehub.com/f/DeterminateSystems/flake-schemas/*";
    nixpkgs.url = "github:NixOS/nixpkgs/c6d65881c5624c9cae5ea6cedef24699b0c0a4c0";
  };

  outputs = { self, flake-schemas, nixpkgs }:
    let
      supportedSystems = [ "x86_64-linux" "aarch64-darwin" "x86_64-darwin" "aarch64-linux" ];
      forEachSupportedSystem = f: nixpkgs.lib.genAttrs supportedSystems (system: f {
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
        inherit system;
      });

      # Map Nix system to release artifact name.
      artifactName = system: {
        "aarch64-darwin" = "Candela-macos-arm64.zip";
        "x86_64-darwin"  = "Candela-macos-arm64.zip";  # Rosetta
        "x86_64-linux"   = "Candela-linux-x64.tar.gz";
        "aarch64-linux"  = "Candela-linux-x64.tar.gz";  # best-effort
      }.${system} or (throw "Unsupported system: ${system}");

      version = "0.2.0";
    in {
      schemas = flake-schemas.schemas;

      # ── Pre-built binary package ──────────────────────────
      # Install via: nix profile install github:candelahq/candela-desktop
      #
      # NOTE: Update sha256 hashes when cutting a new release.
      # Run: nix-prefetch-url <url> to get the hash.
      packages = forEachSupportedSystem ({ pkgs, system }: {
        default = pkgs.stdenv.mkDerivation {
          pname = "candela-desktop";
          inherit version;
          src = pkgs.fetchurl {
            url = "https://github.com/candelahq/candela-desktop/releases/download/v${version}/${artifactName system}";
            # TODO: Update these hashes after first release.
            sha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
          };

          nativeBuildInputs = with pkgs; [
            unzip
          ] ++ pkgs.lib.optionals pkgs.stdenv.isLinux [
            autoPatchelfHook
          ];

          # macOS: unzip .app bundle
          # Linux: extract tar.gz bundle
          unpackPhase = if pkgs.stdenv.isDarwin then ''
            unzip $src
          '' else ''
            tar -xzf $src
          '';

          installPhase = if pkgs.stdenv.isDarwin then ''
            mkdir -p $out/Applications
            cp -R Candela.app $out/Applications/
          '' else ''
            mkdir -p $out/bin $out/lib $out/share/candela
            cp -r * $out/share/candela/
            ln -s $out/share/candela/candela_desktop $out/bin/candela
          '';

          meta = with pkgs.lib; {
            description = "Candela — LLM Observability for your machine";
            homepage = "https://candelahq.com";
            license = licenses.unfree;  # TODO: Set actual license
            platforms = platforms.darwin ++ platforms.linux;
          };
        };
      });

      # ── Development shell ─────────────────────────────────
      devShells = forEachSupportedSystem ({ pkgs, ... }: {
        default = pkgs.mkShell {
          packages = with pkgs; [
            # ── Flutter / Dart SDK ──────────────────────────────
            flutter              # Flutter stable (includes Dart SDK)

            # ── General dev tooling ────────────────────────────
            git
            gh                   # GitHub CLI (PRs, issues, etc.)
            lefthook
            jq                   # handy for JSON config inspection
          ] ++ pkgs.lib.optionals pkgs.stdenv.isDarwin [
            # ── macOS native build tooling ─────────────────────
            cocoapods            # CocoaPods for macOS Runner dependencies
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
