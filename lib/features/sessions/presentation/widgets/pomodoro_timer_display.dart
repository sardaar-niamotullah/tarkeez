import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tarkeez/core/shared_files/cubits/tracking_settings_cubit.dart';
import 'package:tarkeez/core/utils/app_clock.dart';
import 'package:tarkeez/features/sessions/presentation/widgets/timer_digits.dart';

/// Pomodoro countdown as m:ss ("120:00" ... "0:01", "0:00").
class PomodoroTimerDisplay extends StatelessWidget {
  const new({
    super.key,
    required this.isRunning,
    required this.colonVisible,
    required this.endsAt,
  });

  final bool isRunning;
  final bool colonVisible;

  /// Null when idle: the picked length is shown.
  final DateTime? endsAt;

  @override
  Widget build(BuildContext context) {
    final pickedMinutes = context.select(
      (TrackingSettingsCubit c) => c.state.pomodoroMinutes,
    );
    final end = endsAt;
    final leftMs = end == null
        ? pickedMinutes * 60000
        : end.difference(AppClock.now()).inMilliseconds;
    // Rounded up, so "120:00" holds for the first second and "0:01" for the last.
    final seconds = leftMs <= 0 ? 0 : (leftMs + 999) ~/ 1000;

    return TimerDigits(
      left: '${seconds ~/ 60}',
      right: '${seconds % 60}'.padLeft(2, '0'),
      dotsVisible: !isRunning || colonVisible,
    );
  }
}