import 'package:tarkeez/features/daily_rollups/data/models/personal_best_period.dart';
import 'package:tarkeez/features/daily_rollups/utils/daily_rollup_date_utils.dart';

class DailyRollupStats {
  DailyRollupStats._();
  static bool _hasActivity(Map<String, int> rollups, String date) =>
      (rollups[date] ?? 0) > 0;

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

  static int longestStreak(Map<String, int> rollups) {
    final activeDates = rollups.entries
        .where((e) => e.value > 0)
        .map((e) => e.key)
        .toList()
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
}