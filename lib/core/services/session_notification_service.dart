import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:tarkeez/core/services/session_task_handler.dart';
import 'package:tarkeez/core/shared_files/cubits/session_timer_cubit.dart';
import 'package:tarkeez/core/shared_files/cubits/user_preferences_cubit.dart';
import 'package:tarkeez/core/utils/app_clock.dart';
import 'package:tarkeez/features/daily_rollups/bloc/daily_rollup_bloc.dart';

typedef _Content = ({
  String title,
  String text,
  List<NotificationButton> buttons,
});

/// Shows a notification while a session runs. It is a foreground service,
/// so Android keeps the app alive when it is minimized.
class SessionNotificationService {
  SessionNotificationService(this._timer, this._prefs, this._daily) {
    if (!Platform.isAndroid) return;
    FlutterForegroundTask.addTaskDataCallback(_onButton);
    _subs.addAll([
      _timer.stream.listen((_) => _sync(), onDone: dispose),
      _prefs.stream.listen((_) => _sync()),
    ]);
  }

  final SessionTimerCubit _timer;
  final UserPreferencesCubit _prefs;
  final DailyRollupBloc _daily;

  final _subs = <StreamSubscription<dynamic>>[];
  Future<void> _queue = Future.value();
  String? _lastKey;

  /// Call once in main(), before runApp.
  static void init() {
    if (!Platform.isAndroid) return;
    FlutterForegroundTask.initCommunicationPort();
    FlutterForegroundTask.init(
      androidNotificationOptions: AndroidNotificationOptions(
        channelId: 'tarkeez_session',
        channelName: 'Running session',
        channelDescription: 'Shown while a session is being tracked.',
        channelImportance: NotificationChannelImportance.LOW,
        priority: NotificationPriority.LOW,
        onlyAlertOnce: true,
      ),
      iosNotificationOptions: const IOSNotificationOptions(
        showNotification: false,
        playSound: false,
      ),
      foregroundTaskOptions: ForegroundTaskOptions(
        eventAction: ForegroundTaskEventAction.nothing(),
        allowWakeLock: true,
      ),
    );
  }

  // What the notification shows. Null means: no notification.
  _Content? _content() {
    final s = _timer.state;
    final project = s.project?.name ?? 'No project';

    if (_prefs.state.isPomodoro) {
      final paused = !s.isRunning && s.left != null;
      if (!s.isRunning && !paused) return null;

      final end = s.endsAt;
      final leftMs = end != null
          ? end.difference(AppClock.now()).inMilliseconds
          : s.left?.inMilliseconds ?? 0;
      final seconds = leftMs <= 0 ? 0 : (leftMs + 999) ~/ 1000;

      return (
        title: '${seconds ~/ 60}:${_two(seconds % 60)}',
        text: paused ? 'Paused · $project' : project,
        buttons: [
          NotificationButton(id: 'toggle', text: paused ? 'Resume' : 'Pause'),
          const NotificationButton(id: 'reset', text: 'Reset'),
        ],
      );
    }

    if (!s.isRunning) return null;
    final today = switch (_daily.state) {
      DailyRollupLoaded d => d.today,
      _ => 0,
    };
    final total = Duration(seconds: today);
    return (
      title: '${total.inHours}:${_two(total.inMinutes % 60)}',
      text: project,
      buttons: const [NotificationButton(id: 'toggle', text: 'Stop')],
    );
  }

  static String _two(int n) => n.toString().padLeft(2, '0');

  // Runs on every timer tick, but only talks to Android when the text changes:
  // once a minute in linear mode, once a second in pomodoro mode.
  void _sync() {
    final c = _content();
    if (c == null) {
      if (_lastKey != null) {
        _lastKey = null;
        _run(_hide);
      }
      return;
    }
    final key =
        '${c.title}|${c.text}|${c.buttons.map((b) => b.text).join(',')}';
    if (key == _lastKey) return;
    _lastKey = key;
    _run(() => _show(c));
  }

  Future<void> _show(_Content c) async {
    if (await FlutterForegroundTask.isRunningService) {
      await FlutterForegroundTask.updateService(
        notificationTitle: c.title,
        notificationText: c.text,
        notificationButtons: c.buttons,
      );
      return;
    }
    // Android 13+: without this permission the notification stays hidden.
    if (await FlutterForegroundTask.checkNotificationPermission() !=
        NotificationPermission.granted) {
      await FlutterForegroundTask.requestNotificationPermission();
    }
    await FlutterForegroundTask.startService(
      serviceId: 256,
      notificationTitle: c.title,
      notificationText: c.text,
      notificationButtons: c.buttons,
      callback: sessionTaskCallback,
    );
  }

  Future<void> _hide() async {
    if (await FlutterForegroundTask.isRunningService) {
      await FlutterForegroundTask.stopService();
    }
  }

  /// One platform call at a time, in order, so an update never overtakes the start.
  void _run(Future<void> Function() job) {
    _queue = _queue.then((_) => job()).catchError((Object e) {
      debugPrint('Session notification: $e');
    });
  }

  // Same calls as PausePlayButton and the reset button.
  void _onButton(Object data) {
    switch (data) {
      case 'toggle':
        final tracking = _prefs.state;
        _timer.toggle(
          countdown: tracking.isPomodoro
              ? Duration(minutes: tracking.pomodoroMinutes)
              : null,
        );
      case 'reset':
        _timer.reset();
    }
  }

  Future<void> dispose() async {
    if (!Platform.isAndroid) return;
    for (final s in _subs) {
      await s.cancel();
    }
    FlutterForegroundTask.removeTaskDataCallback(_onButton);
    _run(_hide);
  }
}
