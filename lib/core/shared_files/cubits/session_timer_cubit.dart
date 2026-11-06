import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tarkeez/core/services/sound_service.dart';
import 'package:tarkeez/core/utils/app_clock.dart';
import 'package:tarkeez/features/projects/data/models/project_model.dart';
import 'package:tarkeez/features/sessions/bloc/session_bloc.dart';

class SessionTimerState extends Equatable {
  const new({this.project, this.startedAt, this.endsAt, this.tick = 0});

  /// The picked project, also while idle.
  final ProjectModel? project;

  /// Null when idle.
  final DateTime? startedAt;

  /// Pomodoro only: when the countdown reaches 0:00. Null in linear mode.
  /// While idle it means the countdown just finished (shown as 0:00 for a second).
  final DateTime? endsAt;

  /// Half-second steps. Makes every tick a new state.
  final int tick;

  bool get isRunning => startedAt != null;
  bool get colonVisible => tick.isEven;

  @override
  List<Object?> get props => [project, startedAt, endsAt, tick];
}

class SessionTimerCubit extends Cubit<SessionTimerState> {
  new(this._sessions, this._sound) : super(const SessionTimerState());

  final SessionBloc _sessions;
  final SoundService _sound;
  Timer? _timer;

  /// Play / stop button. [countdown] starts a pomodoro of that length.
  void toggle({Duration? countdown}) {
    _sound.playBell();
    state.isRunning ? _stop() : _start(countdown);
  }

  /// Picking a project while running splits the session at this instant:
  /// the running part is saved under the old project, and a new session
  /// starts under the new one. A pomodoro keeps its end time.
  void selectProject(ProjectModel? project) {
    final startedAt = state.startedAt;
    final now = AppClock.now();

    // Under a second there is nothing to save (the repository rejects it),
    // so that session just carries on under the new project.
    if (startedAt != null &&
        project?.id != state.project?.id &&
        now.difference(startedAt) >= const Duration(seconds: 1)) {
      _save(startedAt, now); // state.project is still the old one here
      emit(
        SessionTimerState(
          project: project,
          startedAt: now,
          endsAt: state.endsAt,
        ),
      );
    } else {
      emit(
        SessionTimerState(
          project: project,
          startedAt: startedAt,
          endsAt: state.endsAt,
          tick: state.tick,
        ),
      );
    }
  }

  void _start(Duration? countdown) {
    final now = AppClock.now();
    emit(
      SessionTimerState(
        project: state.project,
        startedAt: now,
        endsAt: countdown == null ? null : now.add(countdown),
      ),
    );
    _scheduleTick();
  }

  void _stop() {
    final startedAt = state.startedAt;
    if (startedAt != null) _save(startedAt, AppClock.now());
    _timer?.cancel();
    emit(SessionTimerState(project: state.project));
  }

  /// Wakes just after the next half-second, so the shown seconds flip on time.
  /// The grid is anchored at the countdown's end (pomodoro) or the start (linear).
  void _scheduleTick() {
    _timer?.cancel();
    final anchor = state.endsAt ?? state.startedAt;
    if (anchor == null) return;
    final ms = AppClock.now().difference(anchor).inMilliseconds;
    _timer = Timer(Duration(milliseconds: 500 - ms % 500 + 5), _onTick);
  }

  void _onTick() {
    final startedAt = state.startedAt;
    final endsAt = state.endsAt;
    final anchor = endsAt ?? startedAt;
    if (startedAt == null || anchor == null) return;

    final now = AppClock.now();
    if (endsAt != null && !now.isBefore(endsAt)) {
      _finish(startedAt, endsAt);
      return;
    }
    emit(
      SessionTimerState(
        project: state.project,
        startedAt: startedAt,
        endsAt: endsAt,
        tick: (now.difference(anchor).inMilliseconds / 500).floor(),
      ),
    );
    _scheduleTick();
  }

  /// The pomodoro reached 0:00: save it, ring, show 0:00 for a second, then reset.
  void _finish(DateTime startedAt, DateTime endsAt) {
    // A part under a second (a project switch right before the end) can't be saved.
    if (endsAt.difference(startedAt) >= const Duration(seconds: 1)) {
      _save(startedAt, endsAt);
    }
    _sound.playBell();
    emit(SessionTimerState(project: state.project, endsAt: endsAt));
    _timer = Timer(
      const Duration(seconds: 1),
      () => emit(SessionTimerState(project: state.project)),
    );
  }

  void _save(DateTime startedAt, DateTime endedAt) {
    _sessions.add(
      EntrySessionRequested(
        startedAt: startedAt,
        endedAt: endedAt,
        project: state.project,
      ),
    );
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}