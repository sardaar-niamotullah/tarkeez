import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:tarkeez/core/services/sound_service.dart';
import 'package:tarkeez/core/utils/app_clock.dart';
import 'package:tarkeez/core/utils/container_design_utils.dart';
import 'package:tarkeez/core/utils/session_log_interface_bottom_clipper.dart';
import 'package:tarkeez/features/projects/data/models/project_model.dart';
import 'package:tarkeez/features/projects/presentation/sections/widgets/select_project_button.dart';
import 'package:tarkeez/features/sessions/presentation/widgets/pause_play_button.dart';
import 'package:tarkeez/features/sessions/presentation/widgets/pomodoro_set_duration_button.dart';
import 'package:tarkeez/features/sessions/presentation/widgets/time_log_timer_display.dart';

class SessionLogInterface extends StatefulWidget {
  const SessionLogInterface({super.key});

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
    });
  }

  void _stopTicker() {
    _tickTimer?.cancel();
    _tickTimer = null;
    setState(() {
      _colonVisible = true;
      _liveElapsed = Duration.zero;
    });
  }

  void _onPausePlayTapped() {
    GetIt.I<SoundService>().playBell();
    if (_isRunning) {
      final startedAt = _startedAt;
      if (startedAt != null) {
        // context.read<SessionLogBloc>().add(
        //   EntrySessionLogRequested(
        //     startedAt: startedAt,
        //     endedAt: AppClock.now(),
        //     project: _selectedProject,
        //   ),
        // );
      }
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
      width: .infinity,
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: ContainerDesignUtils.allRadius,
      ),
      child: Column(
        children: [
          const SizedBox(height: 48),
          // ──────────────────────────────────────────────
          // Timer
          // ──────────────────────────────────────────────
          TimeLogTimerDisplay(
            isRunning: _isRunning,
            liveElapsed: _liveElapsed,
            colonVisible: _colonVisible,
            startedAt: _startedAt,
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
                  padding: const .only(left: 24, right: 48),
                  child: Container(
                    height: 54,
                    padding: .symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: scheme.onSurface,
                      borderRadius: ContainerDesignUtils.allRadius,
                    ),
                    child: Align(
                      alignment: .centerLeft,
                      child: SelectProjectButton(
                        selectedProject: _selectedProject,
                        onProjectSelected: (project) => setState(() {
                          _selectedProject = project;
                        }),
                      ),
                    ),
                  ),
                ),

                // ──────────────────────────────────────────────
                // Pause play button
                // ──────────────────────────────────────────────
                Positioned(
                  right: 36,
                  top: -10,
                  child: PausePlayButton(
                    isRunning: _isRunning,
                    onTap: _onPausePlayTapped,
                  ),
                ),

                // ──────────────────────────────────────────────
                // SessionLogInterfaceBottomClipper
                // ──────────────────────────────────────────────
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
