import 'package:tarkeez/features/daily_rollups/data/models/personal_best_period.dart';
import 'package:tarkeez/features/daily_rollups/utils/daily_rollup_date_utils.dart';

/// Pure statistics over a date -> seconds map. No Bloc/state dependency —
/// testable in isolation with plain Dart maps.
class DailyRollupStats {
  DailyRollupStats._();

  static bool _hasActivity(Map<String, int> rollups, String date) =>
      (rollups[date] ?? 0) > 0;

  //––––––––––––––––––––––––––––––––––––––––––––––––––––––
  // Streaks
  //––––––––––––––––––––––––––––––––––––––––––––––––––––––
  /// Consecutive days up to and including today with activity.
  /// If today has no activity yet, falls back to yesterday so an
  /// in-progress streak doesn't visually reset to 0 before the day ends.
  static int currentStreak(Map<String, int> rollups) {
    final today = DailyRollupDateUtils.todayLocal();
    var cursor = _hasActivity(rollups, today)
        ? today
        : DailyRollupDateUtils.shiftDate(today, -1);

    var streak = 0;
    while (_hasActivity(rollups, cursor)) {
      streak++;
      cursor = DailyRollupDateUtils.shiftDate(cursor, -1);
    }
    return streak;
  }

  /// Longest run of consecutive active days in the given map.
  /// Pass a map that already includes today's live overlay if you want
  /// an in-progress session to count toward this.
  static int longestStreak(Map<String, int> rollups) {
    final activeDates =
        rollups.entries.where((e) => e.value > 0).map((e) => e.key).toList()
          ..sort();

    if (activeDates.isEmpty) return 0;

    var longest = 0;
    var current = 0;
    String? previous;

    for (final date in activeDates) {
      if (previous != null &&
          DailyRollupDateUtils.shiftDate(previous, 1) == date) {
        current++;
      } else {
        current = 1;
      }
      longest = current > longest ? current : longest;
      previous = date;
    }
    return longest;
  }

  //––––––––––––––––––––––––––––––––––––––––––––––––––––––
  // Personal bests
  //––––––––––––––––––––––––––––––––––––––––––––––––––––––
  static PersonalBestPeriod bestDay(Map<String, int> rollups) {
    if (rollups.isEmpty) return PersonalBestPeriod.empty;

    String? bestDate;
    var bestSeconds = -1;
    rollups.forEach((date, seconds) {
      if (seconds > bestSeconds) {
        bestSeconds = seconds;
        bestDate = date;
      }
    });

    return PersonalBestPeriod(
      seconds: bestSeconds,
      label: DailyRollupDateUtils.formatDayLabel(bestDate!),
    );
  }

  static PersonalBestPeriod bestWeek(Map<String, int> rollups) {
    if (rollups.isEmpty) return PersonalBestPeriod.empty;

    final byWeek = <String, int>{};
    rollups.forEach((date, seconds) {
      final key = DailyRollupDateUtils.isoWeekKey(date);
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
    return PersonalBestPeriod(
      seconds: bestSeconds,
      label: 'Week ${int.parse(parts[1])}, ${parts[0]}',
    );
  }

  static PersonalBestPeriod bestMonth(Map<String, int> rollups) {
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

    return PersonalBestPeriod(
      seconds: bestSeconds,
      label: DailyRollupDateUtils.formatMonthLabel(bestKey!),
    );
  }

  static PersonalBestPeriod bestYear(Map<String, int> rollups) {
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

  //––––––––––––––––––––––––––––––––––––––––––––––––––––––
  // Invested times
  //––––––––––––––––––––––––––––––––––––––––––––––––––––––
  /// Inclusive sum of seconds from [start] to [end] ('YYYY-MM-DD' each).
  static int sumRange(Map<String, int> rollups, String start, String end) {
    var sum = 0;
    var cursor = start;
    while (!DailyRollupDateUtils.isAfter(cursor, end)) {
      sum += rollups[cursor] ?? 0;
      cursor = DailyRollupDateUtils.shiftDate(cursor, 1);
    }
    return sum;
  }

  static int today(Map<String, int> rollups) =>
      rollups[DailyRollupDateUtils.todayLocal()] ?? 0;

  static int yesterday(Map<String, int> rollups) =>
      rollups[DailyRollupDateUtils.shiftDate(
        DailyRollupDateUtils.todayLocal(),
        -1,
      )] ??
      0;

  /// Sum from Monday of the current ISO week through today (partial week).
  static int thisWeek(Map<String, int> rollups) {
    final today = DailyRollupDateUtils.todayLocal();
    final start = DailyRollupDateUtils.startOfIsoWeek(today);
    return sumRange(rollups, start, today);
  }

  /// Sum of the full previous ISO week (Mon–Sun).
  static int lastWeek(Map<String, int> rollups) {
    final thisWeekStart = DailyRollupDateUtils.startOfIsoWeek(
      DailyRollupDateUtils.todayLocal(),
    );
    final lastWeekEnd = DailyRollupDateUtils.shiftDate(thisWeekStart, -1);
    final lastWeekStart = DailyRollupDateUtils.shiftDate(lastWeekEnd, -6);
    return sumRange(rollups, lastWeekStart, lastWeekEnd);
  }

  /// Sum from the 1st of this month through today (partial month).
  static int thisMonth(Map<String, int> rollups) {
    final today = DailyRollupDateUtils.todayLocal();
    final start = DailyRollupDateUtils.startOfMonth(today);
    return sumRange(rollups, start, today);
  }

  /// Sum of the full previous calendar month.
  static int lastMonth(Map<String, int> rollups) {
    final thisMonthStart = DailyRollupDateUtils.startOfMonth(
      DailyRollupDateUtils.todayLocal(),
    );
    final lastMonthEnd = DailyRollupDateUtils.shiftDate(thisMonthStart, -1);
    final lastMonthStart = DailyRollupDateUtils.startOfMonth(lastMonthEnd);
    return sumRange(rollups, lastMonthStart, lastMonthEnd);
  }

  /// Sum from Jan 1st of this year through today (partial year).
  static int thisYear(Map<String, int> rollups) {
    final today = DailyRollupDateUtils.todayLocal();
    final start = DailyRollupDateUtils.startOfYear(today);
    return sumRange(rollups, start, today);
  }

  /// Sum of the full previous calendar year.
  static int lastYear(Map<String, int> rollups) {
    final thisYearStart = DailyRollupDateUtils.startOfYear(
      DailyRollupDateUtils.todayLocal(),
    );
    final lastYearEnd = DailyRollupDateUtils.shiftDate(thisYearStart, -1);
    final lastYearStart = DailyRollupDateUtils.startOfYear(lastYearEnd);
    return sumRange(rollups, lastYearStart, lastYearEnd);
  }

  static int last7Days(Map<String, int> rollups) => _sumLastNDays(rollups, 7);
  static int last30Days(Map<String, int> rollups) => _sumLastNDays(rollups, 30);
  static int last365Days(Map<String, int> rollups) =>
      _sumLastNDays(rollups, 365);

  /// Rolling window of n days ending today (inclusive of today).
  static int _sumLastNDays(Map<String, int> rollups, int n) {
    final today = DailyRollupDateUtils.todayLocal();
    final start = DailyRollupDateUtils.shiftDate(today, -(n - 1));
    return sumRange(rollups, start, today);
  }
}
