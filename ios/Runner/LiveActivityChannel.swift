import ActivityKit
import Flutter

/// The iOS end of lib/core/services/session_live_activity_service.dart.
///
/// Dart -> iOS:  "show" (start or update the card), "hide" (end it)
/// iOS -> Dart:  "button" (a card button was tapped: toggle / reset / close)
@available(iOS 16.2, *)
enum LiveActivityChannel {
  static func register(with messenger: FlutterBinaryMessenger) {
    let channel = FlutterMethodChannel(
      name: "tarkeez/live_activity",
      binaryMessenger: messenger
    )

    channel.setMethodCallHandler { call, result in
      switch call.method {
      case "show":
        guard let state = call.arguments as? [String: Any] else {
          result(FlutterError(code: "bad_args", message: "Expected a map", details: nil))
          return
        }
        Task {
          await LiveActivityChannel.show(state)
          result(nil)
        }
      case "hide":
        Task {
          await LiveActivityChannel.hide()
          result(nil)
        }
      default:
        result(FlutterMethodNotImplemented)
      }
    }

    // Buttons on the card -> Dart. Same ids as the Android notification.
    SessionBridge.shared.handler = { action in
      DispatchQueue.main.async {
        channel.invokeMethod("button", arguments: action)
      }
    }

    // The app just started, so no session is running. A card from an earlier
    // run (the app was killed) is stale.
    Task { await LiveActivityChannel.hide() }
  }

  /// Starts the card, or updates it when one is already there.
  private static func show(_ m: [String: Any]) async {
    // Dart sends dates as milliseconds since 1970.
    func date(_ key: String) -> Date? {
      (m[key] as? NSNumber).map { Date(timeIntervalSince1970: $0.doubleValue / 1000) }
    }

    let state = SessionAttributes.ContentState(
      project: m["project"] as? String ?? "",
      isRunning: m["isRunning"] as? Bool ?? false,
      isPomodoro: m["isPomodoro"] as? Bool ?? false,
      from: date("from"),
      to: date("to"),
      seconds: m["seconds"] as? Int ?? 0,
      canReset: m["canReset"] as? Bool ?? false
    )
    let content = ActivityContent(state: state, staleDate: nil)

    if let activity = Activity<SessionAttributes>.activities.first {
      await activity.update(content)
    } else if ActivityAuthorizationInfo().areActivitiesEnabled {
      // Fails quietly when the app is in the background: iOS only lets an
      // app start a card while it is on screen.
      _ = try? Activity<SessionAttributes>.request(
        attributes: SessionAttributes(),
        content: content
      )
    }
  }

  private static func hide() async {
    for activity in Activity<SessionAttributes>.activities {
      await activity.end(nil, dismissalPolicy: .immediate)
    }
  }
}
