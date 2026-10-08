import Cocoa
import FlutterMacOS

class MainFlutterWindow: NSWindow {
  override func awakeFromNib() {
    let flutterViewController = FlutterViewController()
    self.contentViewController = flutterViewController

    let size = NSSize(width: 420, height: 750)
    self.contentMinSize = size
    self.setContentSize(size)

    // Top-right corner
    if let screen = self.screen ?? NSScreen.main {
      let visible = screen.visibleFrame
      let padding: CGFloat = 0
      let origin = NSPoint(
        x: visible.maxX - self.frame.width - padding,
        y: visible.maxY - self.frame.height - padding
      )
      self.setFrameOrigin(origin)
    }

    RegisterGeneratedPlugins(registry: flutterViewController)

    super.awakeFromNib()
  }
}