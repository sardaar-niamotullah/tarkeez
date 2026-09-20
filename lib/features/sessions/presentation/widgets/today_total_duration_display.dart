import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tarkeez/core/theme/app_fonts.dart';
import 'package:tarkeez/core/utils/app_clock.dart';
import 'package:tarkeez/core/utils/text_utils.dart';
import 'package:tarkeez/features/sessions/bloc/session_bloc.dart';
import 'package:tarkeez/features/sessions/data/models/session_model.dart';

class TodayTotalDurationDisplay extends StatelessWidget {
  const TodayTotalDurationDisplay({
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

  static List<SessionModel> _logsFromState(SessionState state) {
    if (state is SessionLoaded) return state.sessions;
    if (state is SessionFailure) return state.sessions;
    if (state is SessionLoading) return state.sessions;
    return const [];
  }

  static Duration _todaysLoggedDuration(List<SessionModel> sessions) {
    final now = AppClock.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    final todayEnd = todayStart.add(const Duration(days: 1));

    var total = Duration.zero;
    for (final session in sessions) {
      final localStart = session.startedAt.toLocal();
      if (!localStart.isBefore(todayStart) && localStart.isBefore(todayEnd)) {
        total += session.endedAt.toLocal().difference(localStart);
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
    final scheme = Theme.of(context).colorScheme;
    return BlocBuilder<SessionBloc, SessionState>(
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
            Container(
              margin: .symmetric(horizontal: 3.5),
              child: Column(
                children: [
                  Container(
                    height: 14,
                    width: 14,
                    decoration: BoxDecoration(
                      color: scheme.onTertiary.withValues(
                        alpha: (isRunning && !colonVisible) ? 0 : .9,
                      ),
                      shape: .circle,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    height: 14,
                    width: 14,
                    decoration: BoxDecoration(
                      color: scheme.onTertiary.withValues(
                        alpha: (isRunning && !colonVisible) ? 0 : .9,
                      ),
                      shape: .circle,
                    ),
                  ),
                ],
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
