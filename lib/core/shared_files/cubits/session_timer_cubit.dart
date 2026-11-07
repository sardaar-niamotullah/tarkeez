import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tarkeez/core/services/sound_service.dart';
import 'package:tarkeez/core/utils/app_clock.dart';
import 'package:tarkeez/features/projects/data/models/project_model.dart';
import 'package:tarkeez/features/sessions/bloc/session_bloc.dart';

class SessionTimerState extends Equatable {
  const new({
    this.project,
    this.startedAt,
    this.endsAt,
    this.left,
    this.tick = 0,
  });

  const SessionTimerState.idle(ProjectModel? project) : this(project: project);

  /// The picked project, also while idle.
  final ProjectModel? project;

  /// Start of the part being timed. Null unless running.
  final DateTime? startedAt;

  /// Pomodoro, running: when the countdown reaches 0:00. Null in linear mode.
  final DateTime? endsAt;

  /// Pomodoro, not running: the time left, frozen on the display. Null when it
  /// is back at the picked length. Zero for the second after it finishes.
  final Duration? left;

  /// Half-second steps. Makes every tick a new state.
  final int tick;

  bool get isRunning => startedAt != null;
  bool get colonVisible => tick.isEven;

  SessionTimerState copyWith({DateTime? endsAt, int? tick}) =>
      SessionTimerState(
        project: project,
        startedAt: startedAt,
        endsAt: endsAt ?? this.endsAt,
        left: left,
        tick: tick ?? this.tick,
      );

  @override
  List<Object?> get props => [project, startedAt, endsAt, left, tick];
}

class SessionTimerCubit extends Cubit<SessionTimerState> {
  new(this._sessions, this._sound) : super(const SessionTimerState());

  final SessionBloc _sessions;
  final SoundService _sound;
  Timer? _timer;

  /// Play button. Linear: starts / stops. Pomodoro: starts / pauses / resumes.
  /// [countdown] is the pomodoro length, null means linear.
  void toggle({Duration? countdown}) {
    _sound.playBell();
    if (!state.isRunning) {
      _start(countdown);
    } else if (state.endsAt == null) {
      reset(); // linear: stop
    } else {
      _pause();
    }
  }

  /// Stops the running session and saves it, then goes back to idle: the
  /// linear stop, the pomodoro reset, and what a tracking-mode switch does.
  void reset() {
    final startedAt = state.startedAt;
    if (startedAt != null) _save(startedAt, AppClock.now());
    _timer?.cancel();
    emit(SessionTimerState.idle(state.project));
  }

  /// Picking a project while running splits the session at this instant:
  /// the running part is saved under the old project, and a new session
  /// starts under the new one. A pomodoro keeps its end time.
  void selectProject(ProjectModel? project) {
    final startedAt = state.startedAt;
    final now = AppClock.now();

    // Under a second there is nothing to save, so that session just carries
    // on under the new project.
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
          left: state.left,
          tick: state.tick,
        ),
      );
    }
  }

  /// The pomodoro length changed by [change] while one runs or is paused: the
  /// time left moves with it. If nothing is left, it finishes now and the whole
  /// running part is recorded.
  void adjustLength(Duration change) {
    if (change == Duration.zero) return;
    final now = AppClock.now();
    final startedAt = state.startedAt;
    final endsAt = state.endsAt;
    final left = state.left;

    if (startedAt != null && endsAt != null) {
      final newEnd = endsAt.add(change);
      if (newEnd.isAfter(now)) {
        emit(state.copyWith(endsAt: newEnd));
        _scheduleTick();
      } else {
        _save(startedAt, now);
        _finish();
      }
    } else if (left != null && left > Duration.zero) {
      final newLeft = left + change;
      if (newLeft > Duration.zero) {
        emit(SessionTimerState(project: state.project, left: newLeft));
      } else {
        _finish(); // paused: that part was saved when it paused
      }
    }
  }

  void _start(Duration? countdown) {
    final now = AppClock.now();
    // A paused pomodoro resumes with the time it had left.
    final left = state.left;
    final length = countdown == null
        ? null
        : (left != null && left > Duration.zero ? left : countdown);

    emit(
      SessionTimerState(
        project: state.project,
        startedAt: now,
        endsAt: length == null ? null : now.add(length),
      ),
    );
    _scheduleTick();
  }

  void _pause() {
    final startedAt = state.startedAt;
    final endsAt = state.endsAt;
    if (startedAt == null || endsAt == null) return;

    final now = AppClock.now();
    _save(startedAt, now);
    _timer?.cancel();
    emit(
      SessionTimerState(project: state.project, left: endsAt.difference(now)),
    );
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
      _save(startedAt, endsAt); // a late tick (app suspended) is not counted
      _finish();
      return;
    }
    emit(
      state.copyWith(
        tick: (now.difference(anchor).inMilliseconds / 500).floor(),
      ),
    );
    _scheduleTick();
  }

  /// The pomodoro is over: ring, show 0:00 for a second, then reset.
  void _finish() {
    _sound.playBell();
    _timer?.cancel();
    emit(SessionTimerState(project: state.project, left: Duration.zero));
    _timer = Timer(
      const Duration(seconds: 1),
      () => emit(SessionTimerState.idle(state.project)),
    );
  }

  void _save(DateTime startedAt, DateTime endedAt) {
    // Under a second the repository would reject it.
    if (endedAt.difference(startedAt) < const Duration(seconds: 1)) return;
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