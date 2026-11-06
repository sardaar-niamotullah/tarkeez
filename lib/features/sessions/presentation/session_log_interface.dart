import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:tailwind_breakpoints/tailwind_breakpoints.dart';
import 'package:tarkeez/core/services/sound_service.dart';
import 'package:tarkeez/core/shared_files/cubits/session_timer_cubit.dart';
import 'package:tarkeez/core/utils/container_design_utils.dart';
import 'package:tarkeez/core/utils/session_log_interface_bottom_clipper.dart';
import 'package:tarkeez/features/projects/presentation/sections/widgets/select_project_button.dart';
import 'package:tarkeez/features/sessions/presentation/widgets/pause_play_button.dart';
import 'package:tarkeez/features/sessions/presentation/widgets/pomodoro_set_duration_button.dart';
import 'package:tarkeez/features/sessions/presentation/widgets/today_total_duration_display.dart';

class SessionLogInterface extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final timer = context.read<SessionTimerCubit>();
    // select: this widget rebuilds when these change, not on every tick.
    final isRunning = context.select(
      (SessionTimerCubit c) => c.state.isRunning,
    );
    final project = context.select((SessionTimerCubit c) => c.state.project);

    return Container(
      height: context.md ? 248 : null,
      width: .infinity,
      decoration: BoxDecoration(
        color: context.md ? scheme.onSurface : scheme.surface,
        borderRadius: ContainerDesignUtils.allRadius,
      ),
      child: Column(
        children: [
          SizedBox(height: context.md ? 32 : 48),
          // ──────────────────────────────────────────────
          // Timer (the only part that rebuilds on every tick)
          // ──────────────────────────────────────────────
          BlocBuilder<SessionTimerCubit, SessionTimerState>(
            builder: (context, s) => TodayTotalDurationDisplay(
              isRunning: s.isRunning,
              colonVisible: s.colonVisible,
            ),
          ),
          const PomodoroSetDurationButton(isPomodoroModeOn: false),
          const SizedBox(height: 16),

          SizedBox(
            height: 77,
            child: Stack(
              clipBehavior: .none,
              children: [
                // ──────────────────────────────────────────────
                // Project section
                // ──────────────────────────────────────────────
                Padding(
                  padding: .only(left: 24, right: context.md ? 24 : 48),
                  child: Container(
                    height: 54,
                    padding: .symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: context.md ? scheme.surface : scheme.onSurface,
                      borderRadius: ContainerDesignUtils.allRadius,
                    ),
                    child: Align(
                      alignment: .centerLeft,
                      child: SelectProjectButton(
                        selectedProject: project,
                        onProjectSelected: timer.selectProject,
                      ),
                    ),
                  ),
                ),

                // ──────────────────────────────────────────────
                // Pause play button
                // ──────────────────────────────────────────────
                Positioned(
                  right: context.md ? 24 : 36,
                  top: -10,
                  child: PausePlayButton(
                    isRunning: isRunning,
                    onTap: () {
                      GetIt.I<SoundService>().playBell();
                      timer.toggle();
                    },
                  ),
                ),

                // ──────────────────────────────────────────────
                // SessionLogInterfaceBottomClipper
                // ──────────────────────────────────────────────
                if (!context.md)
                  Positioned(
                    left: 0,
                    right: 0,
                    top: 12,
                    child: ClipPath(
                      clipper: SessionLogInterfaceBottomClipper(),
                      child: Container(
                        height: 65,
                        width: .infinity,
                        decoration: BoxDecoration(color: scheme.onSurface),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
