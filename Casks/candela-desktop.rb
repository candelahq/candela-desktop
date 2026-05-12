# Homebrew Cask for Candela Desktop
# Auto-updated by the release workflow via the update-cask job.
#
# Manual install:
#   brew install --cask candelahq/tap/candela-desktop
#
# This file lives in candelahq/homebrew-tap → Casks/candela-desktop.rb

cask "candela-desktop" do
  version "0.3.4"
  sha256 "b7f0ae7efd79560b1b2895165b5ff5be5290624c75202a5b8e6ca8f135ab3ec5"

  url "https://github.com/candelahq/candela-desktop/releases/download/v#{version}/Candela-macos-arm64.dmg"
  name "Candela"
  desc "LLM observability for your machine — traces, costs, and budgets for AI dev tools"
  homepage "https://github.com/candelahq/candela-desktop"

  # Only Apple Silicon for now (release matrix only builds arm64).
  # Intel Macs can run via Rosetta 2.
  depends_on arch: :arm64

  # Once the `candela` CLI formula is published (via GoReleaser),
  # users can install it separately: brew install candelahq/tap/candela

  app "Candela.app"

  # Unsigned (ad-hoc signed) — strip quarantine so Gatekeeper doesn't block.
  # Remove this once proper Apple Developer ID signing is in place.
  postflight do
    system_command "/usr/bin/xattr",
                   args: ["-cr", "#{appdir}/Candela.app"],
                   sudo: false
  end

  zap trash: [
    "~/.candela",
    "~/.config/candela",
    "~/Library/Application Support/com.candelahq.candela",
    "~/Library/Caches/com.candelahq.candela",
    "~/Library/Preferences/com.candelahq.candela.plist",
  ]
end
