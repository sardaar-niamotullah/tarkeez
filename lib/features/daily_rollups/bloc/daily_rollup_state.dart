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

  /// A day "counts" toward a streak if it has any recorded duration —
  /// including the live (unsaved) elapsed time for today.
  bool _hasActivity(String date) => durationFor(date) > 0;

  /// Consecutive days up to and including today with activity.
  /// If today has no activity yet, falls back to yesterday so an
  /// in-progress streak doesn't visually reset to 0 before the day ends.
  int get currentStreak {
    final today = _todayLocal();
    var cursor = _hasActivity(today) ? today : _shiftDate(today, -1);

    var streak = 0;
    while (_hasActivity(cursor)) {
      streak++;
      cursor = _shiftDate(cursor, -1);
    }
    return streak;
  }

  /// Longest run of consecutive active days across all recorded history.
  int get longestStreak {
    if (rollupsByDate.isEmpty) return 0;

    final activeDates =
        rollupsByDate.entries
            .where((e) => e.value > 0)
            .map((e) => e.key)
            .toList()
          ..sort();

    var longest = 0;
    var current = 0;
    String? previous;

    for (final date in activeDates) {
      if (previous != null && _shiftDate(previous, 1) == date) {
        current++;
      } else {
        current = 1;
      }
      longest = current > longest ? current : longest;
      previous = date;
    }

    // Today's live-only activity (not yet in rollupsByDate) can still
    // extend an active longest streak — reuse currentStreak for that.
    return longest > currentStreak ? longest : currentStreak;
  }

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

  static String _todayLocal() {
    final now = DateTime.now();
    return '${now.year.toString().padLeft(4, '0')}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }

  static String _shiftDate(String date, int deltaDays) {
    final d = DateTime.parse(date).add(Duration(days: deltaDays));
    return '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
  }
}
