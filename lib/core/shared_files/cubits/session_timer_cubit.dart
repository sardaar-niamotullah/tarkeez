import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tarkeez/core/utils/app_clock.dart';
import 'package:tarkeez/features/projects/data/models/project_model.dart';
import 'package:tarkeez/features/sessions/bloc/session_bloc.dart';

typedef EndedSession = ({DateTime startedAt, DateTime endedAt});

class SessionTimerState extends Equatable {
  const new({
    this.project,
    this.startedAt,
    this.tick = 0,
    this.unsaved = const [],
  });

  /// The picked project, also while idle.
  final ProjectModel? project;

  /// Null when idle.
  final DateTime? startedAt;

  /// Counts 500 ms steps. Makes every tick a new state.
  final int tick;

  /// Sessions sent to SessionBloc that are not in its list yet. The day total
  /// keeps counting them, so it does not dip while they are being saved.
  final List<EndedSession> unsaved;

  bool get isRunning => startedAt != null;
  bool get colonVisible => tick.isEven;

  SessionTimerState copyWith({int? tick, List<EndedSession>? unsaved}) =>
      SessionTimerState(
        project: project,
        startedAt: startedAt,
        tick: tick ?? this.tick,
        unsaved: unsaved ?? this.unsaved,
      );

  @override
  List<Object?> get props => [project, startedAt, tick, unsaved];
}

class SessionTimerCubit extends Cubit<SessionTimerState> {
  new(this._sessions) : super(const SessionTimerState()) {
    _sub = _sessions.stream.listen(_onSessionState);
  }

  final SessionBloc _sessions;
  late final StreamSubscription<SessionState> _sub;
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
      emit(
        SessionTimerState(
          project: project,
          startedAt: now,
          unsaved: _save(startedAt, now), // runs while state.project is still the old one
        ),
      );
    } else {
      emit(
        SessionTimerState(
          project: project,
          startedAt: startedAt,
          tick: state.tick,
          unsaved: state.unsaved,
        ),
      );
    }
  }

  void _start() {
    emit(
      SessionTimerState(
        project: state.project,
        startedAt: AppClock.now(),
        unsaved: state.unsaved,
      ),
    );
    _timer?.cancel();
    _timer = Timer.periodic(
      const Duration(milliseconds: 500),
      (_) => emit(state.copyWith(tick: state.tick + 1)),
    );
  }

  void _stop() {
    final startedAt = state.startedAt;
    if (startedAt == null) return;
    _timer?.cancel();
    emit(
      SessionTimerState(
        project: state.project,
        unsaved: _save(startedAt, AppClock.now()),
      ),
    );
  }

  /// Sends the session to SessionBloc. Returns the unsaved list including it.
  List<EndedSession> _save(DateTime startedAt, DateTime endedAt) {
    _sessions.add(
      EntrySessionRequested(
        startedAt: startedAt,
        endedAt: endedAt,
        project: state.project,
      ),
    );
    return [...state.unsaved, (startedAt: startedAt, endedAt: endedAt)];
  }

  /// SessionBloc has the saved session now (or gave up on it): stop counting it here.
  void _onSessionState(SessionState s) {
    final done = s is SessionFailure || (s is SessionLoaded && s.isEntered);
    if (done && state.unsaved.isNotEmpty) {
      emit(state.copyWith(unsaved: state.unsaved.sublist(1)));
    }
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    _sub.cancel();
    return super.close();
  }
}