part of 'daily_rollup_bloc.dart';

sealed class DailyRollupState {}

class DailyRollupInitial extends DailyRollupState {}

class DailyRollupLoading extends DailyRollupState {
  DailyRollupLoading({this.rollupsByDate, this.isInitialLoad = false});
  final Map<String, int>? rollupsByDate;
  final bool isInitialLoad;
}

class DailyRollupFailure extends DailyRollupState {
  DailyRollupFailure(this.message);
  final String message;
}

class DailyRollupLoaded extends DailyRollupState {
  DailyRollupLoaded({
    required this.rollupsByDate,
    this.liveDate,
    this.liveElapsedSeconds = 0,
  });

  final Map<String, int> rollupsByDate;
  final String? liveDate;
  final int liveElapsedSeconds;

  int durationFor(String date) {
    final base = rollupsByDate[date] ?? 0;
    if (date == liveDate) return base + liveElapsedSeconds;
    return base;
  }

  /// Merges DB-persisted rollups with today's live overlay — the single
  /// map every stats computation below reads from.
  Map<String, int> get _effectiveRollups {
    if (liveDate == null || liveElapsedSeconds == 0) return rollupsByDate;
    return Map<String, int>.from(rollupsByDate)
      ..[liveDate!] = durationFor(liveDate!);
  }

  int get currentStreak => DailyRollupStats.currentStreak(_effectiveRollups);
  int get longestStreak => DailyRollupStats.longestStreak(_effectiveRollups);

  PersonalBestPeriod get bestDay => DailyRollupStats.bestDay(_effectiveRollups);
  PersonalBestPeriod get bestWeek =>
      DailyRollupStats.bestWeek(_effectiveRollups);
  PersonalBestPeriod get bestMonth =>
      DailyRollupStats.bestMonth(_effectiveRollups);
  PersonalBestPeriod get bestYear =>
      DailyRollupStats.bestYear(_effectiveRollups);

  DailyRollupLoaded copyWith({
    Map<String, int>? rollupsByDate,
    String? liveDate,
    int? liveElapsedSeconds,
    bool clearLive = false,
  }) => DailyRollupLoaded(
    rollupsByDate: rollupsByDate ?? this.rollupsByDate,
    liveDate: clearLive ? null : (liveDate ?? this.liveDate),
    liveElapsedSeconds: clearLive
        ? 0
        : (liveElapsedSeconds ?? this.liveElapsedSeconds),
  );
}
