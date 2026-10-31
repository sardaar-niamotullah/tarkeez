import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter/foundation.dart' show listEquals;
import 'package:tarkeez/core/utils/app_clock.dart';
import 'package:tarkeez/core/utils/live_session_slices.dart';
import 'package:tarkeez/core/utils/rollup_date_utils.dart';
import 'package:tarkeez/core/shared_files/enums/period_range.dart';
import 'package:tarkeez/features/project_rollups/data/models/project_duration_model.dart';
import 'package:tarkeez/features/project_rollups/data/models/project_rollup_model.dart';
import 'package:tarkeez/features/project_rollups/data/repositories/project_rollup_repository.dart';
import 'package:tarkeez/features/project_rollups/stats/pie_chart_stats.dart';
import 'package:tarkeez/features/projects/data/models/project_model.dart';

part 'project_rollup_event.dart';
part 'project_rollup_state.dart';

class ProjectRollupBloc extends Bloc<ProjectRollupEvent, ProjectRollupState> {
  new(this._repository, Stream<void> syncedSessions)
    : super(ProjectRollupInitial()) {
    on<FetchProjectRollupRequested>(_onFetch);
    on<RefreshProjectRollupRequested>(_onRefresh);
    on<ProjectRollupSynced>(_onSynced, transformer: restartable());
    on<ProjectRollupLiveTicked>(_onLiveTicked);
    on<ProjectRollupLiveStopped>(_onLiveStopped);

    _syncSub = syncedSessions.listen((_) => add(ProjectRollupSynced()));
  }

  final ProjectRollupRepository _repository;
  late final StreamSubscription<void> _syncSub;

  /// Saved rows only (the live part is never merged into them).
  List<ProjectRollupModel>? get _currentRollups => switch (state) {
    ProjectRollupLoaded(:final persisted) => persisted,
    ProjectRollupLoading(:final rollups) => rollups,
    ProjectRollupFailure(:final rollups) => rollups,
    _ => null,
  };

  Future<void> _onFetch(
    FetchProjectRollupRequested event,
    Emitter<ProjectRollupState> emit,
  ) async {
    final previous = _currentRollups;
    emit(ProjectRollupLoading(rollups: previous, isInitialLoad: true));

    final result = await _repository.fetchAllRollups();

    result.fold(
      onSuccess: (rollups) => emit(ProjectRollupLoaded(persisted: rollups)),
      onFailure: (error) =>
          emit(ProjectRollupFailure(error.message, rollups: previous)),
    );
  }

  Future<void> _onRefresh(
    RefreshProjectRollupRequested event,
    Emitter<ProjectRollupState> emit,
  ) async {
    if (_currentRollups == null) return;

    final result = await _repository.fetchRecentRollups(days: event.days);

    result.fold(
      onSuccess: (recent) {
        final current = _currentRollups;
        if (current == null) return;
        final now = DateTime.now();
        final windowStart = RollupDateUtils.format(
          DateTime(now.year, now.month, now.day - event.days),
        );
        final merged = [
          ...current.where((r) => r.date.compareTo(windowStart) < 0),
          ...recent,
        ];
        emit(ProjectRollupLoaded(persisted: merged));
      },
      onFailure: (error) =>
          emit(ProjectRollupFailure(error.message, rollups: _currentRollups)),
    );
  }

  /// Sync or delete changed the sessions. A running session stays visible.
  Future<void> _onSynced(
    ProjectRollupSynced event,
    Emitter<ProjectRollupState> emit,
  ) async {
    final result = await _repository.fetchAllRollups();
    result.fold(
      onSuccess: (rollups) {
        final current = state;
        emit(
          current is ProjectRollupLoaded
              ? current.copyWith(persisted: rollups)
              : ProjectRollupLoaded(persisted: rollups),
        );
      },
      onFailure: (_) {},
    );
  }

  void _onLiveTicked(
    ProjectRollupLiveTicked event,
    Emitter<ProjectRollupState> emit,
  ) {
    final current = state;
    if (current is! ProjectRollupLoaded) return;

    final slices = LiveSessionSlices.split(event.startedAt, AppClock.now());
    final live = [
      for (final e in slices.entries)
        ProjectRollupModel(
          date: e.key,
          projectId: event.projectId,
          durationSeconds: e.value,
        ),
    ];
    // The timer widget ticks twice a second, the seconds change once.
    // The project can also change mid-session, so compare the rows, not the total.
    if (listEquals(live, current.live)) return;

    emit(current.copyWith(live: live));
  }

  /// The running session ended (saved or failed). Re-reads SQLite and drops the
  /// live part in the same emit, so the session is never counted twice.
  Future<void> _onLiveStopped(
    ProjectRollupLiveStopped event,
    Emitter<ProjectRollupState> emit,
  ) async {
    final result = await _repository.fetchAllRollups();
    final current = state;
    if (current is! ProjectRollupLoaded) return;

    result.fold(
      onSuccess: (rollups) =>
          emit(current.copyWith(persisted: rollups, live: const [])),
      onFailure: (_) => emit(current.copyWith(live: const [])),
    );
  }

  @override
  Future<void> close() {
    _syncSub.cancel();
    return super.close();
  }
}