import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:tailwind_breakpoints/tailwind_breakpoints.dart';
import 'package:tarkeez/core/services/sound_service.dart';
import 'package:tarkeez/core/utils/app_clock.dart';
import 'package:tarkeez/core/utils/container_design_utils.dart';
import 'package:tarkeez/core/utils/session_log_interface_bottom_clipper.dart';
import 'package:tarkeez/features/projects/data/models/project_model.dart';
import 'package:tarkeez/features/projects/presentation/sections/widgets/select_project_button.dart';
import 'package:tarkeez/features/sessions/bloc/session_bloc.dart';
import 'package:tarkeez/features/sessions/presentation/widgets/pause_play_button.dart';
import 'package:tarkeez/features/sessions/presentation/widgets/pomodoro_set_duration_button.dart';
import 'package:tarkeez/features/sessions/presentation/widgets/today_total_duration_display.dart';
import 'package:tarkeez/features/daily_rollups/bloc/daily_rollup_bloc.dart';
import 'package:tarkeez/features/project_rollups/bloc/project_rollup_bloc.dart';

class SessionLogInterface extends StatefulWidget {
  const new({super.key});

  @override
  State<SessionLogInterface> createState() => _SessionLogInterfaceState();
}

class _SessionLogInterfaceState extends State<SessionLogInterface> {
  ProjectModel? _selectedProject;
  bool _isRunning = false;
  DateTime? _startedAt;
  Timer? _tickTimer;
  bool _colonVisible = true;
  Duration _liveElapsed = Duration.zero;

  @override
  void dispose() {
    _tickTimer?.cancel();
    super.dispose();
  }

  void _startTicker() {
    _tickTimer?.cancel();
    _tickTimer = Timer.periodic(const Duration(milliseconds: 500), (_) {
      final startedAt = _startedAt;
      setState(() {
        _colonVisible = !_colonVisible;
        if (startedAt != null) {
          _liveElapsed = AppClock.now().difference(startedAt);
        }
      });
      if (startedAt != null) _pushLiveToStats(startedAt);
    });
  }

  void _pushLiveToStats(DateTime startedAt) {
    context.read<DailyRollupBloc>().add(DailyRollupLiveTicked(startedAt));
    context.read<ProjectRollupBloc>().add(
      ProjectRollupLiveTicked(startedAt, _selectedProject?.id),
    );
  }

  void _stopTicker() {
    _tickTimer?.cancel();
    _tickTimer = null;
    setState(() {
      _colonVisible = true;
      _liveElapsed = Duration.zero;
    });
  }

  void _saveSession(DateTime startedAt, DateTime endedAt) {
    context.read<SessionBloc>().add(
      EntrySessionRequested(
        startedAt: startedAt,
        endedAt: endedAt,
        project: _selectedProject,
      ),
    );
  }

  void _onProjectSelected(ProjectModel? project) {
    final startedAt = _startedAt;
    final now = AppClock.now();
    final switched = project?.id != _selectedProject?.id;

    // Under a second there is nothing to save (the repository rejects it),
    // so that session just carries on under the new project.
    if (startedAt != null &&
        switched &&
        now.difference(startedAt) >= const Duration(seconds: 1)) {
      _saveSession(
        startedAt,
        now,
      ); // _selectedProject is still the old one here
      setState(() {
        _startedAt = now;
        _liveElapsed = Duration.zero;
        _selectedProject = project;
      });
    } else {
      setState(() => _selectedProject = project);
    }
  }

  void _onPausePlayTapped() {
    GetIt.I<SoundService>().playBell();
    if (_isRunning) {
      final startedAt = _startedAt;
      if (startedAt != null) _saveSession(startedAt, AppClock.now());
      _stopTicker();
      setState(() {
        _isRunning = false;
        _startedAt = null;
      });
    } else {
      setState(() {
        _isRunning = true;
        _startedAt = AppClock.now();
      });
      _startTicker();
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

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
          // Timer
          // ──────────────────────────────────────────────
          TodayTotalDurationDisplay(
            isRunning: _isRunning,
            liveElapsed: _liveElapsed,
            colonVisible: _colonVisible,
            startedAt: _startedAt,
          ),
          const PomodoroSetDurationButton(isPomodoroModeOn: true),
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
                        selectedProject: _selectedProject,
                        onProjectSelected: _onProjectSelected,
                      )
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
                    isRunning: _isRunning,
                    onTap: _onPausePlayTapped,
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
