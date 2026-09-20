import 'package:bloc/bloc.dart';
import 'package:tarkeez/features/daily_rollups/data/repositories/daily_rollup_repository.dart';
import 'package:tarkeez/features/profile/presentation/sections/personal_bests_section.dart';

part 'daily_rollup_event.dart';
part 'daily_rollup_state.dart';

class DailyRollupBloc extends Bloc<DailyRollupEvent, DailyRollupState> {
  final DailyRollupRepository _repository;

  DailyRollupBloc(this._repository) : super(DailyRollupInitial()) {
    on<FetchDailyRollupRequested>(_onFetchDailyRollupRequested);
    on<RefreshDailyRollupRequested>(_onRefreshDailyRollupRequested);
    on<DailyRollupLiveTicked>(_onLiveTicked);
    on<DailyRollupLiveStopped>(_onLiveStopped);
  }

  // ── Private helpers ─────────────────────────────────────────────────────
  Future<void> _onFetchDailyRollupRequested(
    FetchDailyRollupRequested event,
    Emitter<DailyRollupState> emit,
  ) async {
    final previousRollups = state is DailyRollupLoaded
        ? (state as DailyRollupLoaded).rollupsByDate
        : null;
    emit(
      DailyRollupLoading(rollupsByDate: previousRollups, isInitialLoad: true),
    );
    final result = await _repository.fetchAllRollups();
    result.fold(
      onSuccess: (rollups) => emit(
        DailyRollupLoaded(
          rollupsByDate: {for (final r in rollups) r.date: r.durationSeconds},
        ),
      ),
      onFailure: (error) => emit(DailyRollupFailure(error.message)),
    );
  }

  Future<void> _onRefreshDailyRollupRequested(
    RefreshDailyRollupRequested event,
    Emitter<DailyRollupState> emit,
  ) async {
    final current = state;
    if (current is! DailyRollupLoaded) return;

    final result = await _repository.fetchRecentRollups(days: event.days);
    result.fold(
      onSuccess: (recent) {
        final merged = Map<String, int>.from(current.rollupsByDate)
          ..addEntries(recent.map((r) => MapEntry(r.date, r.durationSeconds)));
        emit(current.copyWith(rollupsByDate: merged, clearLive: true));
      },
      onFailure: (error) => emit(DailyRollupFailure(error.message)),
    );
  }

  void _onLiveTicked(
    DailyRollupLiveTicked event,
    Emitter<DailyRollupState> emit,
  ) {
    final current = state;
    if (current is! DailyRollupLoaded) return;

    final elapsed = DateTime.now().difference(event.timerStartedAt).inSeconds;
    emit(current.copyWith(liveDate: _todayLocal(), liveElapsedSeconds: elapsed));
  }

  void _onLiveStopped(
    DailyRollupLiveStopped event,
    Emitter<DailyRollupState> emit,
  ) {
    final current = state;
    if (current is! DailyRollupLoaded) return;
    emit(current.copyWith(clearLive: true));
  }

  String _todayLocal() {
    final now = DateTime.now();
    return '${now.year.toString().padLeft(4, '0')}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }
}