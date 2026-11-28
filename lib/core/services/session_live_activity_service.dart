import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:tarkeez/core/shared_files/cubits/session_timer_cubit.dart';
import 'package:tarkeez/core/shared_files/cubits/user_preferences_cubit.dart';
import 'package:tarkeez/core/utils/app_clock.dart';
import 'package:tarkeez/features/daily_rollups/bloc/daily_rollup_bloc.dart';

/// iOS twin of SessionNotificationService. Shows a running session as a Live
/// Activity: on the Lock Screen, and in the Dynamic Island on iPhones that
/// have one. It does nothing on Android and on iOS older than 16.2.
///
/// iOS draws the ticking numbers itself, so a new state is sent only when
/// something changes (start, pause, project, length), never every second.
class SessionLiveActivityService {
  new(this._timer, this._prefs, this._daily) {
    if (!Platform.isIOS) return;
    _channel.setMethodCallHandler(_onCall);
    _subs.addAll([
      _timer.stream.listen((_) => _sync(), onDone: dispose),
      _prefs.stream.listen((_) => _sync()),
      _daily.stream.listen((_) => _sync()),
    ]);
  }

  /// Same name as in LiveActivityChannel.swift.
  static const _channel = MethodChannel('tarkeez/live_activity');

  final SessionTimerCubit _timer;
  final UserPreferencesCubit _prefs;
  final DailyRollupBloc _daily;

  final _subs = <StreamSubscription<dynamic>>[];
  Future<void> _queue = Future.value();
  String? _lastKey;

  /// True from the first running session until the user taps close.
  bool _pinned = false;

  /// Linear mode: the card counts up from this moment, which is "now minus
  /// today's saved total". Set once per run, so a project switch keeps it.
  DateTime? _anchor;

  int get _today => switch (_daily.state) {
    DailyRollupLoaded d => d.today,
    _ => 0,
  };

  // What the card shows. Null means: no card.
  Map<String, Object?>? _content() {
    final s = _timer.state;
    final pomodoro = _prefs.state.isPomodoro;
    final left = s.left;
    final paused =
        pomodoro && !s.isRunning && left != null && left > Duration.zero;

    if (!s.isRunning) _anchor = null;
    if (!s.isRunning && !paused && !_pinned) return null;

    final int seconds;
    if (s.isRunning) {
      seconds = 0; // iOS draws the running time
      if (!pomodoro) {
        _anchor ??= AppClock.now().subtract(Duration(seconds: _today));
      }
    } else if (paused) {
      seconds = (left.inMilliseconds + 999) ~/ 1000;
    } else {
      seconds = pomodoro ? _prefs.state.pomodoroMinutes * 60 : _today;
    }

    return {
      'project': s.project?.name ?? 'No project',
      'isRunning': s.isRunning,
      'isPomodoro': pomodoro,
      'from': (pomodoro ? s.startedAt : _anchor)?.millisecondsSinceEpoch,
      'to': s.endsAt?.millisecondsSinceEpoch,
      'seconds': seconds,
      'canReset': pomodoro && (s.isRunning || paused),
    };
  }

  // Runs on every timer tick, but only talks to iOS when the content changes.
  void _sync() {
    if (_timer.state.isRunning) _pinned = true;

    final c = _content();
    if (c == null) {
      if (_lastKey != null) {
        _lastKey = null;
        _run(() => _channel.invokeMethod<void>('hide'));
      }
      return;
    }
    final key = c.toString();
    if (key == _lastKey) return;
    _lastKey = key;
    _run(() => _channel.invokeMethod<void>('show', c));
  }

  /// One platform call at a time, in order, so an update never overtakes the start.
  void _run(Future<void> Function() job) {
    _queue = _queue.then((_) => job()).catchError((Object e) {
      // iOS older than 16.2 has no channel on the native side. That is fine.
      if (e is! MissingPluginException) {
        debugPrint('Session live activity: $e');
      }
    });
  }

  // Native -> Dart: a button on the card was tapped.
  Future<void> _onCall(MethodCall call) async {
    if (call.method == 'button') _onButton(call.arguments as String);
  }

  // Same calls as the Android notification buttons.
  void _onButton(String id) {
    switch (id) {
      case 'toggle':
        final tracking = _prefs.state;
        _timer.toggle(
          countdown: tracking.isPomodoro
              ? Duration(minutes: tracking.pomodoroMinutes)
              : null,
        );
      case 'reset':
        _timer.reset();
      case 'close':
        // Stops and saves a running session, then removes the card.
        _pinned = false;
        _timer.reset();
        _sync(); // reset emits nothing when already idle
    }
  }

  Future<void> dispose() async {
    if (!Platform.isIOS) return;
    _pinned = false;
    for (final s in _subs) {
      await s.cancel();
    }
    _channel.setMethodCallHandler(null);
    _run(() => _channel.invokeMethod<void>('hide'));
  }
}