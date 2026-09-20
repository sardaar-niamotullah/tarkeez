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

  //––––––––––––––––––––––––––––––––––––––––––––––––––––––
  // Streaks
  //––––––––––––––––––––––––––––––––––––––––––––––––––––––

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

  //––––––––––––––––––––––––––––––––––––––––––––––––––––––
  // Personal bests
  //––––––––––––––––––––––––––––––––––––––––––––––––––––––

  /// Merges DB-persisted rollups with today's live overlay into one
  /// date -> seconds map, so bests reflect the in-progress session too.
  Map<String, int> get _effectiveRollups {
    if (liveDate == null || liveElapsedSeconds == 0) return rollupsByDate;
    final merged = Map<String, int>.from(rollupsByDate);
    merged[liveDate!] = durationFor(liveDate!);
    return merged;
  }

  /// Best single day — label e.g. '1 Sep, 2026'.
  PersonalBestPeriod get bestDay {
    final rollups = _effectiveRollups;
    if (rollups.isEmpty) return PersonalBestPeriod.empty;
    String? bestDate;
    var bestSeconds = -1;
    rollups.forEach((date, seconds) {
      if (seconds > bestSeconds) {
        bestSeconds = seconds;
        bestDate = date;
      }
    });

    return PersonalBestPeriod(seconds: bestSeconds, label: _formatDayLabel(bestDate!));
  }

  /// Best ISO calendar week (Mon–Sun) — label e.g. 'Week 36, 2026'.
  PersonalBestPeriod get bestWeek {
    final rollups = _effectiveRollups;
    if (rollups.isEmpty) return PersonalBestPeriod.empty;

    // key: 'isoYear-Wweek' e.g. '2026-W36'
    final byWeek = <String, int>{};
    rollups.forEach((date, seconds) {
      final key = _isoWeekKey(date);
      byWeek[key] = (byWeek[key] ?? 0) + seconds;
    });

    String? bestKey;
    var bestSeconds = -1;
    byWeek.forEach((key, seconds) {
      if (seconds > bestSeconds) {
        bestSeconds = seconds;
        bestKey = key;
      }
    });

    final parts = bestKey!.split('-W');
    final isoYear = parts[0];
    final isoWeek = int.parse(parts[1]);

    return PersonalBestPeriod(seconds: bestSeconds, label: 'Week $isoWeek, $isoYear');
  }

  /// Best calendar month — label e.g. 'Sep, 2026'.
  PersonalBestPeriod get bestMonth {
    final rollups = _effectiveRollups;
    if (rollups.isEmpty) return PersonalBestPeriod.empty;

    final byMonth = <String, int>{};
    rollups.forEach((date, seconds) {
      final key = date.substring(0, 7); // 'YYYY-MM'
      byMonth[key] = (byMonth[key] ?? 0) + seconds;
    });

    String? bestKey;
    var bestSeconds = -1;
    byMonth.forEach((key, seconds) {
      if (seconds > bestSeconds) {
        bestSeconds = seconds;
        bestKey = key;
      }
    });

    return PersonalBestPeriod(seconds: bestSeconds, label: _formatMonthLabel(bestKey!));
  }

  /// Best calendar year — label e.g. '2026'.
  PersonalBestPeriod get bestYear {
    final rollups = _effectiveRollups;
    if (rollups.isEmpty) return PersonalBestPeriod.empty;

    final byYear = <String, int>{};
    rollups.forEach((date, seconds) {
      final key = date.substring(0, 4); // 'YYYY'
      byYear[key] = (byYear[key] ?? 0) + seconds;
    });

    String? bestKey;
    var bestSeconds = -1;
    byYear.forEach((key, seconds) {
      if (seconds > bestSeconds) {
        bestSeconds = seconds;
        bestKey = key;
      }
    });

    return PersonalBestPeriod(seconds: bestSeconds, label: bestKey!);
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

  //––––––––––––––––––––––––––––––––––––––––––––––––––––––
  // Date helpers
  //––––––––––––––––––––––––––––––––––––––––––––––––––––––

  static String _todayLocal() {
    final now = DateTime.now();
    return '${now.year.toString().padLeft(4, '0')}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }

  static String _shiftDate(String date, int deltaDays) {
    final d = DateTime.parse(date).add(Duration(days: deltaDays));
    return '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
  }

  static const _monthNames = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  /// '2026-09-01' -> '1 Sep, 2026'
  static String _formatDayLabel(String date) {
    final d = DateTime.parse(date);
    return '${d.day} ${_monthNames[d.month - 1]}, ${d.year}';
  }

  /// '2026-09' -> 'Sep, 2026'
  static String _formatMonthLabel(String monthKey) {
    final parts = monthKey.split('-');
    final year = parts[0];
    final month = int.parse(parts[1]);
    return '${_monthNames[month - 1]}, $year';
  }

  /// Returns ISO 8601 week key ('YYYY-Www') for a 'YYYY-MM-DD' date.
  /// ISO weeks start Monday; week 1 is the week containing the year's
  /// first Thursday (equivalently, containing Jan 4th).
  static String _isoWeekKey(String date) {
    final d = DateTime.parse(date);
    // Thursday of this date's ISO week: shift to Monday, then +3 days.
    final weekday = d.weekday; // Mon=1 ... Sun=7
    final thursday = d.add(Duration(days: 4 - weekday));
    final isoYear = thursday.year;

    final jan4 = DateTime(isoYear, 1, 4);
    final jan4Weekday = jan4.weekday;
    final week1Monday = jan4.subtract(Duration(days: jan4Weekday - 1));

    final diffDays = thursday
        .add(const Duration(days: -3)) // back to this week's Monday
        .difference(week1Monday)
        .inDays;
    final isoWeek = (diffDays / 7).floor() + 1;

    return '$isoYear-W${isoWeek.toString().padLeft(2, '0')}';
  }
}
