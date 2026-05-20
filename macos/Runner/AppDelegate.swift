import Cocoa
import FlutterMacOS

@main
class AppDelegate: FlutterAppDelegate {
  override func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
    return false
  }

  override func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
    return true
  }

  /// Re-show the main window when the user clicks the dock icon while
  /// the app is running but the window is hidden (minimized to tray).
  /// Without this, clicking the dock icon does nothing and the user
  /// sees an infinite spinner / bouncing dock icon.
  override func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
    if !flag {
      for window in sender.windows {
        if window is MainFlutterWindow {
          window.makeKeyAndOrderFront(self)
          return true
        }
      }
    }
    return true
  }
}
