import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
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

    _syncSub = syncedSessions.listen((_) => add(ProjectRollupSynced()));
  }

  final ProjectRollupRepository _repository;
  late final StreamSubscription<void> _syncSub;

  List<ProjectRollupModel>? get _currentRollups => switch (state) {
    ProjectRollupLoaded(:final rollups) => rollups,
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
      onSuccess: (rollups) => emit(ProjectRollupLoaded(rollups: rollups)),
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
        emit(ProjectRollupLoaded(rollups: merged));
      },
      onFailure: (error) =>
          emit(ProjectRollupFailure(error.message, rollups: _currentRollups)),
    );
  }

  Future<void> _onSynced(
    ProjectRollupSynced event,
    Emitter<ProjectRollupState> emit,
  ) async {
    final result = await _repository.fetchAllRollups();
    result.fold(
      onSuccess: (rollups) => emit(ProjectRollupLoaded(rollups: rollups)),
      onFailure: (_) {},
    );
  }

  @override
  Future<void> close() {
    _syncSub.cancel();
    return super.close();
  }
}
