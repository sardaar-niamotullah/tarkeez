import 'package:bloc/bloc.dart';
import 'package:tarkeez/core/shared_files/enums/period_range.dart';
import 'package:tarkeez/core/utils/rollup_date_utils.dart';
import 'package:tarkeez/features/project_rollups/data/models/project_duration_model.dart';
import 'package:tarkeez/features/project_rollups/data/models/project_rollup_model.dart';
import 'package:tarkeez/features/project_rollups/data/repositories/project_rollup_repository.dart';
import 'package:tarkeez/features/project_rollups/stats/pie_chart_stats.dart';
import 'package:tarkeez/features/projects/data/models/project_model.dart';

part 'project_rollup_event.dart';
part 'project_rollup_state.dart';

class ProjectRollupBloc extends Bloc<ProjectRollupEvent, ProjectRollupState> {
  ProjectRollupBloc(this._repository) : super(ProjectRollupInitial()) {
    on<FetchProjectRollupRequested>(_onFetch);
    on<RefreshProjectRollupRequested>(_onRefresh);
  }

  final ProjectRollupRepository _repository;

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
    if (_currentRollups == null) return; // nothing loaded yet

    final result = await _repository.fetchRecentRollups(days: event.days);

    result.fold(
      onSuccess: (recent) {
        // Read state AFTER the await so overlapping refreshes don't merge
        // into a stale snapshot.
        final current = _currentRollups;
        if (current == null) return;

        // Same window the repository queried: today - days .. today.
        final now = DateTime.now();
        final windowStart = RollupDateUtils.format(
          DateTime(now.year, now.month, now.day - event.days),
        );

        // Replace the whole window instead of upserting. A session edit can
        // move time between projects, so a row inside the window may no
        // longer exist and must be dropped.
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
}
