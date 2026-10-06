cask "tokenviewer" do
  version "0.1.3"
  sha256 "0fa7f6637987bd33d33ec4fd3a1de3917a92ddcdf181521d27574a1c15c7d701"

  url "https://github.com/jdragon96/TokenViewer/releases/download/v#{version}/TokenViewer-macos.zip"
  name "TokenViewer"
  desc "Menu bar meter for Claude Code plan usage limits"
  homepage "https://github.com/jdragon96/TokenViewer"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: :sonoma

  app "TokenViewer.app"

  # SIGTERM instead of `quit`, which would ask for Automation permission.
  uninstall signal: [["TERM", "com.tokenviewer.TokenViewer"]],
            script: {
              executable:   "#{appdir}/TokenViewer.app/Contents/MacOS/TokenViewer",
              args:         ["--unregister-login-item"],
              must_succeed: false,
            }

  zap trash: [
    "~/Library/Logs/TokenViewer",
    "~/Library/Preferences/com.tokenviewer.TokenViewer.plist",
  ]

  caveats <<~EOS
    TokenViewer is not notarized yet, so macOS blocks its first launch.
    Open System Settings > Privacy & Security and click "Open Anyway", or run:
      xattr -dr com.apple.quarantine "#{appdir}/TokenViewer.app"
  EOS
end
