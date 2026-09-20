import 'package:tarkeez/features/daily_rollups/utils/daily_rollup_date_utils.dart';

class InvestedTimeStats {
  InvestedTimeStats._();

  /// Inclusive sum of seconds from start to end ('YYYY-MM-DD' each).
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
