import ActivityKit
import AppIntents
import SwiftUI
import WidgetKit

typealias SessionState = SessionAttributes.ContentState

struct TarkeezWidgetsLiveActivity: Widget {
  var body: some WidgetConfiguration {
    ActivityConfiguration(for: SessionAttributes.self) { context in
      // Lock Screen and banner. iPhones without a Dynamic Island show only this.
      HStack(spacing: 12) {
        VStack(alignment: .leading, spacing: 2) {
          Text(context.state.project)
            .font(.subheadline)
            .foregroundStyle(.secondary)
            .lineLimit(1)
          TimerText(state: context.state)
            .font(.system(size: 40, weight: .semibold))
        }
        Controls(state: context.state)
      }
      .padding(16)
    } dynamicIsland: { context in
      DynamicIsland {
        DynamicIslandExpandedRegion(.leading) {
          Text(context.state.project)
            .font(.headline)
            .lineLimit(1)
        }
        DynamicIslandExpandedRegion(.trailing) {
          TimerText(state: context.state, trailing: true)
            .font(.title2.weight(.semibold))
            .frame(width: 110)
        }
        DynamicIslandExpandedRegion(.bottom) {
          Controls(state: context.state)
            .frame(maxWidth: .infinity)
        }
      } compactLeading: {
        Image(systemName: "timer")
      } compactTrailing: {
        TimerText(state: context.state, trailing: true)
          .font(.caption)
          .frame(width: 52)
      } minimal: {
        Image(systemName: "timer")
      }
    }
  }
}

/// The time. While running, iOS ticks it by itself:
/// linear counts up from `from`, pomodoro counts down to `to`.
struct TimerText: View {
  let state: SessionState
  var trailing = false

  var body: some View {
    text
      .monospacedDigit()
      .lineLimit(1)
      .minimumScaleFactor(0.6)
      .multilineTextAlignment(trailing ? .trailing : .leading)
      .frame(maxWidth: .infinity, alignment: trailing ? .trailing : .leading)
  }

  private var text: Text {
    if state.isRunning, let from = state.from {
      if let to = state.to {
        return Text(timerInterval: from...max(from, to), countsDown: true, showsHours: false)
      }
      return Text(from, style: .timer)
    }
    // Not running: linear shows h:mm:ss, pomodoro shows m:ss.
    let s = state.seconds
    return Text(
      state.isPomodoro
        ? String(format: "%d:%02d", s / 60, s % 60)
        : String(format: "%d:%02d:%02d", s / 3600, s % 3600 / 60, s % 60)
    )
  }
}

/// Play / pause (stop in linear mode), reset, close. Buttons need iOS 17;
/// on iOS 16 the card is read-only and a tap opens the app.
struct Controls: View {
  let state: SessionState

  var body: some View {
    if #available(iOS 17.0, *) {
      HStack(spacing: 10) {
        button("toggle", icon: toggleIcon)
        if state.canReset { button("reset", icon: "arrow.counterclockwise") }
        button("close", icon: "xmark")
      }
    }
  }

  private var toggleIcon: String {
    if !state.isRunning { return "play.fill" }
    return state.isPomodoro ? "pause.fill" : "stop.fill"
  }

  @available(iOS 17.0, *)
  private func button(_ action: String, icon: String) -> some View {
    Button(intent: SessionActionIntent(action: action)) {
      Image(systemName: icon)
        .font(.system(size: 16, weight: .semibold))
        .frame(width: 38, height: 38)
        .background(Circle().fill(Color.primary.opacity(0.18)))
    }
    .buttonStyle(.plain)
  }
}

// MARK: - Previews
// Xcode only: Editor > Canvas. Delete this block if it ever gives an error;
// nothing else depends on it.

@available(iOS 17.0, *)
extension SessionAttributes {
  fileprivate static var preview: SessionAttributes { SessionAttributes() }
}

@available(iOS 17.0, *)
extension SessionState {
  fileprivate static var linearRunning: SessionState {
    SessionState(
      project: "Tarkeez", isRunning: true, isPomodoro: false,
      from: Date().addingTimeInterval(-3725), seconds: 0, canReset: false)
  }
  fileprivate static var linearStopped: SessionState {
    SessionState(
      project: "Tarkeez", isRunning: false, isPomodoro: false,
      seconds: 7325, canReset: false)
  }
  fileprivate static var pomodoroRunning: SessionState {
    SessionState(
      project: "Deep work", isRunning: true, isPomodoro: true,
      from: Date(), to: Date().addingTimeInterval(25 * 60), seconds: 0, canReset: true)
  }
  fileprivate static var pomodoroPaused: SessionState {
    SessionState(
      project: "Deep work", isRunning: false, isPomodoro: true,
      seconds: 1500, canReset: true)
  }
}

@available(iOS 17.0, *)
#Preview("Lock Screen", as: .content, using: SessionAttributes.preview) {
  TarkeezWidgetsLiveActivity()
} contentStates: {
  SessionState.linearRunning
  SessionState.linearStopped
  SessionState.pomodoroRunning
  SessionState.pomodoroPaused
}

@available(iOS 17.0, *)
#Preview("Island expanded", as: .dynamicIsland(.expanded), using: SessionAttributes.preview) {
  TarkeezWidgetsLiveActivity()
} contentStates: {
  SessionState.linearRunning
  SessionState.linearStopped
  SessionState.pomodoroRunning
  SessionState.pomodoroPaused
}

@available(iOS 17.0, *)
#Preview("Island compact", as: .dynamicIsland(.compact), using: SessionAttributes.preview) {
  TarkeezWidgetsLiveActivity()
} contentStates: {
  SessionState.linearRunning
  SessionState.linearStopped
  SessionState.pomodoroRunning
  SessionState.pomodoroPaused
}

@available(iOS 17.0, *)
#Preview("Island minimal", as: .dynamicIsland(.minimal), using: SessionAttributes.preview) {
  TarkeezWidgetsLiveActivity()
} contentStates: {
  SessionState.linearRunning
  SessionState.linearStopped
  SessionState.pomodoroRunning
  SessionState.pomodoroPaused
}