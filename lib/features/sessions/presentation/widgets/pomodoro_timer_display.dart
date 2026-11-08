import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tarkeez/core/shared_files/cubits/user_preferences_cubit.dart';
import 'package:tarkeez/core/utils/app_clock.dart';
import 'package:tarkeez/features/sessions/presentation/widgets/timer_digits.dart';

/// Pomodoro countdown as m:ss ("120:00" ... "0:01", "0:00").
class PomodoroTimerDisplay extends StatelessWidget {
  const new({super.key, required this.endsAt, required this.left});

  /// Running: when the countdown ends.
  final DateTime? endsAt;

  /// Paused: the time left, frozen. Null and not running: the picked length.
  final Duration? left;

  @override
  Widget build(BuildContext context) {
    final pickedMinutes = context.select(
      (UserPreferencesCubit c) => c.state.pomodoroMinutes,
    );
    final end = endsAt;
    final frozen = left;
    final leftMs = end != null
        ? end.difference(AppClock.now()).inMilliseconds
        : frozen?.inMilliseconds ?? pickedMinutes * 60000;
    // Rounded up, so "120:00" holds for the first second and "0:01" for the last.
    final seconds = leftMs <= 0 ? 0 : (leftMs + 999) ~/ 1000;

    return TimerDigits(
      left: '${seconds ~/ 60}',
      right: '${seconds % 60}'.padLeft(2, '0'),
    );
  }
}
