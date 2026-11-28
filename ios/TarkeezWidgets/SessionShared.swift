// Member of BOTH targets: Runner and TarkeezWidgets
// (File Inspector > Target Membership).
import ActivityKit
import AppIntents
import Foundation

/// Everything the card shows. Dart sends a new one when something changes
/// (start, pause, project, length), not every second: iOS draws the ticking
/// numbers itself from `from` and `to`.
@available(iOS 16.2, *)
struct SessionAttributes: ActivityAttributes {
  struct ContentState: Codable, Hashable {
    var project: String
    var isRunning: Bool
    var isPomodoro: Bool
    /// Linear, running: the timer counts up from here.
    /// Pomodoro, running: when it started.
    var from: Date?
    /// Pomodoro, running: when the countdown ends.
    var to: Date?
    /// Not running: the time to show, in seconds.
    var seconds: Int
    /// Pomodoro, running or paused: show the reset button.
    var canReset: Bool
  }
}

/// Lets a card button reach Dart. The Runner sets `handler` once Flutter is up.
final class SessionBridge: @unchecked Sendable {
  static let shared = SessionBridge()
  var handler: ((String) -> Void)?
}

/// A button on the card (iOS 17+). iOS runs it in the app's process, which is
/// why this file must also be in the Runner target.
@available(iOS 17.0, *)
struct SessionActionIntent: LiveActivityIntent {
  static let title: LocalizedStringResource = "Session action"

  @Parameter(title: "Action") var action: String

  init() {}
  init(action: String) { self.action = action }

  func perform() async throws -> some IntentResult {
    if let handler = SessionBridge.shared.handler {
      handler(action)
      // Give Dart a moment to update the card before iOS suspends the app again.
      try? await Task.sleep(nanoseconds: 500_000_000)
    } else {
      // The app was closed, so the session is gone: end the stale card.
      for activity in Activity<SessionAttributes>.activities {
        await activity.end(nil, dismissalPolicy: .immediate)
      }
    }
    return .result()
  }
}
