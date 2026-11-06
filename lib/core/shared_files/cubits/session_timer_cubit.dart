import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tarkeez/core/utils/app_clock.dart';
import 'package:tarkeez/features/projects/data/models/project_model.dart';
import 'package:tarkeez/features/sessions/bloc/session_bloc.dart';

class SessionTimerState extends Equatable {
  const new({this.project, this.startedAt, this.tick = 0});

  /// The picked project, also while idle.
  final ProjectModel? project;

  /// Null when idle.
  final DateTime? startedAt;

  /// Counts 500 ms steps. Makes every tick a new state.
  final int tick;

  bool get isRunning => startedAt != null;
  bool get colonVisible => tick.isEven;

  SessionTimerState ticked() =>
      SessionTimerState(project: project, startedAt: startedAt, tick: tick + 1);

  @override
  List<Object?> get props => [project, startedAt, tick];
}

class SessionTimerCubit extends Cubit<SessionTimerState> {
  new(this._sessions) : super(const SessionTimerState());

  final SessionBloc _sessions;
  Timer? _timer;

  /// Play / stop button.
  void toggle() => state.isRunning ? _stop() : _start();

  /// Picking a project while running splits the session at this instant:
  /// the running part is saved under the old project, and a new session
  /// starts under the new one.
  void selectProject(ProjectModel? project) {
    final startedAt = state.startedAt;
    final now = AppClock.now();

    // Under a second there is nothing to save (the repository rejects it),
    // so that session just carries on under the new project.
    if (startedAt != null &&
        project?.id != state.project?.id &&
        now.difference(startedAt) >= const Duration(seconds: 1)) {
      _save(startedAt, now); // state.project is still the old one here
      emit(SessionTimerState(project: project, startedAt: now));
    } else {
      emit(
        SessionTimerState(
          project: project,
          startedAt: startedAt,
          tick: state.tick,
        ),
      );
    }
  }

  void _start() {
    emit(SessionTimerState(project: state.project, startedAt: AppClock.now()));
    _timer?.cancel();
    _timer = Timer.periodic(
      const Duration(milliseconds: 500),
      (_) => emit(state.ticked()),
    );
  }

  void _stop() {
    final startedAt = state.startedAt;
    if (startedAt != null) _save(startedAt, AppClock.now());
    _timer?.cancel();
    emit(SessionTimerState(project: state.project));
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