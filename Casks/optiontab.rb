cask "optiontab" do
  version "1.1.2"
  # Replace this with the output of `shasum -a 256 OptionTab-1.1.2.dmg`
  sha256 "f49e2930f11a9d627b7fd4cbb62132867460d860a0c5efb5509dd5078641b5e3"

  # Replace this with the actual URL to your GitHub release DMG
  url "https://github.com/basarsubasi/option-tab-macos/releases/download/v#{version}/OptionTab-#{version}.dmg"
  name "OptionTab"
  desc "Fast and minimal alt-tab behavior for macOS"
  homepage "https://github.com/basarsubasi/option-tab-macos"

  depends_on macos: :ventura

  app "OptionTab.app"

  # Run after the app is copied to Applications
  postflight_steps do
    # Remove the quarantine flag to prevent the "damaged app" warning
    run "xattr",
        args: ["-cr", "{{appdir}}/OptionTab.app"]

    # Launch the app after installation
    run "open",
        args:         ["-a", "OptionTab"],
        must_succeed: false
  end

  # ==========================================
  # UNINSTALLATION & CLEANUP LOGIC
  # ==========================================

  # 1. Reset Accessibility Permissions via terminal
  uninstall_preflight_steps do
    run "tccutil",
        args:         ["reset", "Accessibility", "com.optiontab.app"],
        must_succeed: false
  end

  # 2. Quit the app and remove it from macOS Login Items
  uninstall quit:       "com.optiontab.app",
            login_item: "OptionTab"

  # 3. Trash UserDefaults and settings
  zap trash: [
    "~/Library/Application Scripts/com.optiontab.app",
    "~/Library/Preferences/com.optiontab.app.plist",
  ]
end
