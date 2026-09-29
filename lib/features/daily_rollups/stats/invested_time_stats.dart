import 'package:tarkeez/core/utils/rollup_date_utils.dart';

class InvestedTimeStats {
  InvestedTimeStats._();

  /// Inclusive sum of seconds from start to end ('YYYY-MM-DD' each).
  static int sumRange(Map<String, int> rollups, String start, String end) {
    var sum = 0;
    var cursor = start;
    while (!RollupDateUtils.isAfter(cursor, end)) {
      sum += rollups[cursor] ?? 0;
      cursor = RollupDateUtils.shiftDate(cursor, 1);
    }
    return sum;
  }

  static int today(Map<String, int> rollups) =>
      rollups[RollupDateUtils.todayLocal()] ?? 0;

  static int yesterday(Map<String, int> rollups) =>
      rollups[RollupDateUtils.shiftDate(
        RollupDateUtils.todayLocal(),
        -1,
      )] ??
      0;

  /// Sum from Monday of the current ISO week through today (partial week).
  static int thisWeek(Map<String, int> rollups) {
    final today = RollupDateUtils.todayLocal();
    final start = RollupDateUtils.startOfIsoWeek(today);
    return sumRange(rollups, start, today);
  }

  /// Sum of the full previous ISO week (Mon–Sun).
  static int lastWeek(Map<String, int> rollups) {
    final thisWeekStart = RollupDateUtils.startOfIsoWeek(
      RollupDateUtils.todayLocal(),
    );
    final lastWeekEnd = RollupDateUtils.shiftDate(thisWeekStart, -1);
    final lastWeekStart = RollupDateUtils.shiftDate(lastWeekEnd, -6);
    return sumRange(rollups, lastWeekStart, lastWeekEnd);
  }

  /// Sum from the 1st of this month through today (partial month).
  static int thisMonth(Map<String, int> rollups) {
    final today = RollupDateUtils.todayLocal();
    final start = RollupDateUtils.startOfMonth(today);
    return sumRange(rollups, start, today);
  }

  /// Sum of the full previous calendar month.
  static int lastMonth(Map<String, int> rollups) {
    final thisMonthStart = RollupDateUtils.startOfMonth(
      RollupDateUtils.todayLocal(),
    );
    final lastMonthEnd = RollupDateUtils.shiftDate(thisMonthStart, -1);
    final lastMonthStart = RollupDateUtils.startOfMonth(lastMonthEnd);
    return sumRange(rollups, lastMonthStart, lastMonthEnd);
  }

  /// Sum from Jan 1st of this year through today (partial year).
  static int thisYear(Map<String, int> rollups) {
    final today = RollupDateUtils.todayLocal();
    final start = RollupDateUtils.startOfYear(today);
    return sumRange(rollups, start, today);
  }

  /// Sum of the full previous calendar year.
  static int lastYear(Map<String, int> rollups) {
    final thisYearStart = RollupDateUtils.startOfYear(
      RollupDateUtils.todayLocal(),
    );
    final lastYearEnd = RollupDateUtils.shiftDate(thisYearStart, -1);
    final lastYearStart = RollupDateUtils.startOfYear(lastYearEnd);
    return sumRange(rollups, lastYearStart, lastYearEnd);
  }

  static int last7Days(Map<String, int> rollups) => _sumLastNDays(rollups, 7);
  static int last30Days(Map<String, int> rollups) => _sumLastNDays(rollups, 30);
  static int last365Days(Map<String, int> rollups) =>
      _sumLastNDays(rollups, 365);

  /// Rolling window of n days ending today (inclusive of today).
  static int _sumLastNDays(Map<String, int> rollups, int n) {
    final today = RollupDateUtils.todayLocal();
    final start = RollupDateUtils.shiftDate(today, -(n - 1));
    return sumRange(rollups, start, today);
  }
}
