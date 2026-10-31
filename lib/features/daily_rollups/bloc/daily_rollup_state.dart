part of 'daily_rollup_bloc.dart';

sealed class DailyRollupState {}

class DailyRollupInitial extends DailyRollupState {}

class DailyRollupLoading extends DailyRollupState {
  new({this.rollupsByDate, this.isInitialLoad = false});
  final Map<String, int>? rollupsByDate;
  final bool isInitialLoad;
}

class DailyRollupFailure extends DailyRollupState {
  new(this.message);
  final String message;
}

class DailyRollupLoaded extends DailyRollupState {
  new({required this.rollupsByDate, this.liveByDate = const {}});

  /// Saved totals from SQLite: 'YYYY-MM-DD' -> seconds.
  final Map<String, int> rollupsByDate;

  /// Seconds of the running session per local day (two entries when it
  /// crosses midnight). Empty when no session is running.
  final Map<String, int> liveByDate;

  /// Saved totals plus the running session: the single map every stat below
  /// reads from. `late final` builds it once per state, not once per getter.
  late final Map<String, int> _effectiveRollups = liveByDate.isEmpty
      ? rollupsByDate
      : {
          ...rollupsByDate,
          for (final e in liveByDate.entries)
            e.key: (rollupsByDate[e.key] ?? 0) + e.value,
        };

  int durationFor(String date) => _effectiveRollups[date] ?? 0;

  int totalSecondsForPeriod(PeriodRange period) {
    final range = period.dateRange();
    if (range == null) {
      return _effectiveRollups.values.fold<int>(0, (a, b) => a + b);
    }
    final (start, end) = range;
    return InvestedTimeStats.sumRange(
      _effectiveRollups,
      RollupDateUtils.format(start),
      RollupDateUtils.format(end),
    );
  }

  // Heatmap
  List<HeatmapDay> get heatmapGrid => HeatmapStats.buildGrid(_effectiveRollups);
  // Barchart
  List<TimelineModel> timelineForPeriod(PeriodRange period) =>
      TimelineStats.timelineForPeriod(_effectiveRollups, period);

  //––––––––––––––––––––––––––––––––––––––––––––––––––––––
  // Streaks
  //––––––––––––––––––––––––––––––––––––––––––––––––––––––
  int get currentStreak => StreakStats.currentStreak(_effectiveRollups);
  int get longestStreak => StreakStats.longestStreak(_effectiveRollups);

  //––––––––––––––––––––––––––––––––––––––––––––––––––––––
  // Personal bests
  //––––––––––––––––––––––––––––––––––––––––––––––––––––––
  PersonalBestPeriod get bestDay =>
      PersonalBestStats.bestDay(_effectiveRollups);
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
    Map<String, int>? liveByDate,
    bool clearLive = false,
  }) => DailyRollupLoaded(
    rollupsByDate: rollupsByDate ?? this.rollupsByDate,
    liveByDate: clearLive ? const {} : (liveByDate ?? this.liveByDate),
  );
}
