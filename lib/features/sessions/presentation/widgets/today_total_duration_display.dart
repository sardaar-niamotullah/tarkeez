import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tailwind_breakpoints/tailwind_breakpoints.dart';
import 'package:tarkeez/core/theme/app_fonts.dart';
import 'package:tarkeez/core/utils/text_utils.dart';
import 'package:tarkeez/features/daily_rollups/bloc/daily_rollup_bloc.dart';

class TodayTotalDurationDisplay extends StatelessWidget {
  const new({super.key, required this.isRunning, required this.colonVisible});

  final bool isRunning;
  final bool colonVisible;

  static (String, String) _formatDuration(Duration d) {
    final hours = d.inHours.toString();
    final minutes = (d.inMinutes % 60).toString().padLeft(2, '0');
    return (hours, minutes);
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return BlocBuilder<DailyRollupBloc, DailyRollupState>(
      builder: (context, state) {
        // Saved rows plus the running session, swapped in one emit when saved.
        final todaySeconds = state is DailyRollupLoaded ? state.today : 0;
        final parts = _formatDuration(Duration(seconds: todaySeconds));

        return Row(
          mainAxisSize: .min,
          crossAxisAlignment: .center,
          children: [
            Text(
              parts.$1,
              style:
                  TextUtils.title1(
                    context,
                    fontFamily: AppFontFamily.poppins,
                  ).copyWith(
                    fontSize: context.between(Breakpoints.md, Breakpoints.lg)
                        ? 64
                        : 84,
                  ),
            ),
            Container(
              margin: .symmetric(horizontal: 3.5),
              child: Column(
                children: [
                  Container(
                    height: context.between(Breakpoints.md, Breakpoints.lg)
                        ? 12
                        : 14,
                    width: context.between(Breakpoints.md, Breakpoints.lg)
                        ? 12
                        : 14,
                    decoration: BoxDecoration(
                      color: scheme.onTertiary.withValues(
                        alpha: (isRunning && !colonVisible) ? 0 : .9,
                      ),
                      shape: .circle,
                    ),
                  ),
                  SizedBox(
                    height: context.between(Breakpoints.md, Breakpoints.lg)
                        ? 10
                        : 12,
                  ),
                  Container(
                    height: context.between(Breakpoints.md, Breakpoints.lg)
                        ? 12
                        : 14,
                    width: context.between(Breakpoints.md, Breakpoints.lg)
                        ? 12
                        : 14,
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
              style:
                  TextUtils.title1(
                    context,
                    fontFamily: AppFontFamily.poppins,
                  ).copyWith(
                    fontSize: context.between(Breakpoints.md, Breakpoints.lg)
                        ? 64
                        : 84,
                  ),
            ),
          ],
        );
      },
    );
  }
}
