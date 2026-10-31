import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:tarkeez/core/extensions/period_range_extension.dart';
import 'package:tarkeez/core/shared_files/enums/period_range.dart';
import 'package:tarkeez/core/utils/rollup_date_utils.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:tarkeez/features/daily_rollups/data/models/personal_best_period.dart';
import 'package:tarkeez/features/daily_rollups/data/models/timeline_model.dart';
import 'package:tarkeez/features/daily_rollups/data/repositories/daily_rollup_repository.dart';
import 'package:tarkeez/features/daily_rollups/stats/invested_time_stats.dart';
import 'package:tarkeez/features/daily_rollups/stats/personal_best_stats.dart';
import 'package:tarkeez/features/daily_rollups/stats/streak_stats.dart';
import 'package:tarkeez/features/daily_rollups/stats/timeline_stats.dart';
import 'package:tarkeez/features/daily_rollups/data/models/heatmap_day.dart';
import 'package:tarkeez/features/daily_rollups/stats/heatmap_stats.dart';
import 'package:flutter/foundation.dart' show mapEquals;
import 'package:tarkeez/core/utils/app_clock.dart';
import 'package:tarkeez/core/utils/live_session_slices.dart';

part 'daily_rollup_event.dart';
part 'daily_rollup_state.dart';

class DailyRollupBloc extends Bloc<DailyRollupEvent, DailyRollupState> {
  new(this._repository, Stream<void> syncedSessions)
    : super(DailyRollupInitial()) {
    on<FetchDailyRollupRequested>(_onFetchDailyRollupRequested);
    on<RefreshDailyRollupRequested>(_onRefreshDailyRollupRequested);
    on<DailyRollupLiveTicked>(_onLiveTicked);
    on<DailyRollupLiveStopped>(_onLiveStopped);
    on<DailyRollupSynced>(_onSynced, transformer: restartable());

    _syncSub = syncedSessions.listen((_) => add(DailyRollupSynced()));
  }
  final DailyRollupRepository _repository;
  late final StreamSubscription<void> _syncSub;

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

    final live = LiveSessionSlices.split(event.timerStartedAt, AppClock.now());
    // The timer widget ticks twice a second, the seconds change once.
    if (mapEquals(live, current.liveByDate)) return;

    emit(current.copyWith(liveByDate: live));
  }

  Future<void> _onLiveStopped(
    DailyRollupLiveStopped event,
    Emitter<DailyRollupState> emit,
  ) => _reload(emit, clearLive: true);

  Future<void> _onSynced(
    DailyRollupSynced event,
    Emitter<DailyRollupState> emit,
  ) => _reload(emit, clearLive: false);

  Future<void> _reload(
    Emitter<DailyRollupState> emit, {
    required bool clearLive,
  }) async {
    final result = await _repository.fetchAllRollups();
    final current = state;
    result.fold(
      onSuccess: (rollups) {
        final byDate = {for (final r in rollups) r.date: r.durationSeconds};
        emit(
          current is DailyRollupLoaded
              ? current.copyWith(rollupsByDate: byDate, clearLive: clearLive)
              : DailyRollupLoaded(rollupsByDate: byDate),
        );
      },
      onFailure: (_) {
        if (clearLive && current is DailyRollupLoaded) {
          emit(current.copyWith(clearLive: true));
        }
      },
    );
  }

  @override
  Future<void> close() {
    _syncSub.cancel();
    return super.close();
  }
}
