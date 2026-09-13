import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tarkeez/core/theme/app_fonts.dart';
import 'package:tarkeez/core/utils/app_clock.dart';
import 'package:tarkeez/core/utils/text_utils.dart';
import 'package:tarkeez/features/time_logs/bloc/time_log_bloc.dart';
import 'package:tarkeez/features/time_logs/data/models/time_log_model.dart';

class TimeLogTimerDisplay extends StatelessWidget {
  const TimeLogTimerDisplay({
    super.key,
    required this.isRunning,
    required this.liveElapsed,
    required this.colonVisible,
    required this.startedAt,
  });

  final bool isRunning;
  final Duration liveElapsed;
  final bool colonVisible;
  final DateTime? startedAt;

  static List<TimeLogModel> _logsFromState(TimeLogState state) {
    if (state is TimeLogLoaded) return state.timeLogs;
    if (state is TimeLogFailure) return state.timeLogs;
    if (state is TimeLogLoading) return state.timeLogs;
    return const [];
  }

  static Duration _todaysLoggedDuration(List<TimeLogModel> logs) {
    final now = AppClock.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    final todayEnd = todayStart.add(const Duration(days: 1));

    var total = Duration.zero;
    for (final log in logs) {
      final localStart = log.startedAt.toLocal();
      if (!localStart.isBefore(todayStart) && localStart.isBefore(todayEnd)) {
        total += log.endedAt.toLocal().difference(localStart);
      }
    }
    return total;
  }

  static Duration _todaysLivePortion(DateTime? startedAt) {
    if (startedAt == null) return Duration.zero;
    final now = AppClock.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    final effectiveStart = startedAt.toLocal().isBefore(todayStart)
        ? todayStart
        : startedAt.toLocal();
    final elapsed = now.difference(effectiveStart);
    return elapsed.isNegative ? Duration.zero : elapsed;
  }

  static (String, String) _formatDuration(Duration d) {
    if (d.isNegative) d = Duration.zero;
    final hours = d.inHours.toString();
    final minutes = (d.inMinutes % 60).toString().padLeft(2, '0');
    return (hours, minutes);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TimeLogBloc, TimeLogState>(
      builder: (context, state) {
        final persistedToday = _todaysLoggedDuration(_logsFromState(state));
        final liveToday = isRunning
            ? _todaysLivePortion(startedAt)
            : Duration.zero;
        final total = persistedToday + liveToday;
        final parts = _formatDuration(total);

        return Row(
          mainAxisSize: .min,
          crossAxisAlignment: .center,
          children: [
            Text(
              parts.$1,
              style: TextUtils.title1(
                context,
                fontFamily: AppFontFamily.poppins,
              ).copyWith(fontSize: 84),
            ),
            Transform.translate(
              offset: const Offset(0, -6.5),
              child: Opacity(
                opacity: (isRunning && !colonVisible) ? 0 : 1,
                child: Text(
                  ':',
                  style: TextUtils.title1(
                    context,
                    fontFamily: AppFontFamily.poppins,
                  ).copyWith(fontSize: 84),
                ),
              ),
            ),
            Text(
              parts.$2,
              style: TextUtils.title1(
                context,
                fontFamily: AppFontFamily.poppins,
              ).copyWith(fontSize: 84),
            ),
          ],
        );
      },
    );
  }
}
