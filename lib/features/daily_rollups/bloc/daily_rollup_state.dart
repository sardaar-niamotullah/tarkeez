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

  //––––––––––––––––––––––––––––––––––––––––––––––––––––––
  // Streaks
  //––––––––––––––––––––––––––––––––––––––––––––––––––––––
  int get currentStreak => StreakStats.currentStreak(_effectiveRollups);
  int get longestStreak => StreakStats.longestStreak(_effectiveRollups);

  //––––––––––––––––––––––––––––––––––––––––––––––––––––––
  // Personal bests
  //––––––––––––––––––––––––––––––––––––––––––––––––––––––
  PersonalBestPeriod get bestDay => PersonalBestStats.bestDay(_effectiveRollups);
  PersonalBestPeriod get bestWeek =>
      PersonalBestStats.bestWeek(_effectiveRollups);
  PersonalBestPeriod get bestMonth =>
      PersonalBestStats.bestMonth(_effectiveRollups);
  PersonalBestPeriod get bestYear =>
      PersonalBestStats.bestYear(_effectiveRollups);

  //––––––––––––––––––––––––––––––––––––––––––––––––––––––
  // Invested times
  //––––––––––––––––––––––––––––––––––––––––––––––––––––––
  int get today => InvestedTimeStats.today(_effectiveRollups);
  int get yesterday => InvestedTimeStats.yesterday(_effectiveRollups);
  int get thisWeek => InvestedTimeStats.thisWeek(_effectiveRollups);
  int get lastWeek => InvestedTimeStats.lastWeek(_effectiveRollups);
  int get thisMonth => InvestedTimeStats.thisMonth(_effectiveRollups);
  int get lastMonth => InvestedTimeStats.lastMonth(_effectiveRollups);
  int get thisYear => InvestedTimeStats.thisYear(_effectiveRollups);
  int get lastYear => InvestedTimeStats.lastYear(_effectiveRollups);
  int get last7Days => InvestedTimeStats.last7Days(_effectiveRollups);
  int get last30Days => InvestedTimeStats.last30Days(_effectiveRollups);
  int get last365Days => InvestedTimeStats.last365Days(_effectiveRollups);

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