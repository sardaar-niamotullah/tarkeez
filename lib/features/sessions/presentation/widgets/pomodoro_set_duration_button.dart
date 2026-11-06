import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tailwind_breakpoints/tailwind_breakpoints.dart';
import 'package:tarkeez/core/constants/svg_paths.dart';
import 'package:tarkeez/core/shared_files/cubits/session_timer_cubit.dart';
import 'package:tarkeez/core/shared_files/cubits/tracking_settings_cubit.dart';
import 'package:tarkeez/core/shared_files/snackbar/snack_bar_public_api.dart';
import 'package:tarkeez/core/utils/container_design_utils.dart';
import 'package:tarkeez/core/utils/date_time_formatter.dart';
import 'package:tarkeez/core/utils/duration_text_utils.dart';
import 'package:tarkeez/core/utils/text_utils.dart';
import 'package:tarkeez/features/daily_rollups/bloc/daily_rollup_bloc.dart';
import 'package:tarkeez/features/home/presentation/sections/widgets/set_pomodoro_duration_bottom_sheet.dart';

class PomodoroSetDurationButton extends StatelessWidget {
  const new({super.key, required this.isPomodoroModeOn});
  final bool isPomodoroModeOn;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    // The length is fixed while a pomodoro runs.
    final isRunning = context.select(
      (SessionTimerCubit c) => c.state.isRunning,
    );
    final minutes = context.select(
      (TrackingSettingsCubit c) => c.state.pomodoroMinutes,
    );
    final settings = context.read<TrackingSettingsCubit>();

    return Row(
      mainAxisAlignment: .center,
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: !isPomodoroModeOn || isRunning
                ? null
                : () => showModalBottomSheet<void>(
                    context: context,
                    builder: (_) => SetPomodoroDurationBottomSheet(
                      initialMinutes: minutes,
                      onDurationPicked: settings.setPomodoroMinutes,
                    ),
                  ),
            mouseCursor: SystemMouseCursors.click,
            borderRadius: ContainerDesignUtils.allRadius,
            child: Ink(
              padding: .symmetric(
                horizontal: ContainerDesignUtils.padding,
                vertical: ContainerDesignUtils.quarterPadding,
              ),
              decoration: BoxDecoration(
                color: context.md ? scheme.surface : scheme.onSurface,
                borderRadius: ContainerDesignUtils.allRadius,
              ),
              child: Text(
                isPomodoroModeOn ? 'Set duration' : 'Today',
                style: TextUtils.paragraphSmallBold(context),
              ),
            ),
          ),
        ),

        if (isPomodoroModeOn) ...[
          const SizedBox(width: 8),
          BlocBuilder<DailyRollupBloc, DailyRollupState>(
            builder: (context, state) {
              final todaySeconds = state is DailyRollupLoaded ? state.today : 0;
              return Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    final durationText =
                        DateTimeFormatter.formatDurationSeconds(todaySeconds);
                    showInfoSnackBar(
                      context,
                      message: 'Today\'s total invested time: $durationText',
                      iconPath: SvgPaths.stopwatch,
                    );
                  },
                  mouseCursor: SystemMouseCursors.click,
                  borderRadius: ContainerDesignUtils.allRadius,
                  child: Ink(
                    padding: .symmetric(
                      horizontal: ContainerDesignUtils.padding,
                      vertical: ContainerDesignUtils.quarterPadding,
                    ),
                    decoration: BoxDecoration(
                      color: context.md ? scheme.surface : scheme.onSurface,
                      borderRadius: ContainerDesignUtils.allRadius,
                    ),
                    child: DurationTextUtils(
                      durationInSeconds: todaySeconds,
                      fontSizePrimary: 12,
                      fontSizeSeconday: 10,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ],
    );
  }
}
