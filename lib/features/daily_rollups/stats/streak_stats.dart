import 'package:tarkeez/features/daily_rollups/utils/daily_rollup_date_utils.dart';

class StreakStats {
  StreakStats._();

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
}
