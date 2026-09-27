import 'package:tarkeez/features/daily_rollups/data/models/heatmap_day.dart';
import 'package:tarkeez/features/daily_rollups/utils/daily_rollup_date_utils.dart';

class HeatmapStats {
  HeatmapStats._();

  static const int weeksToShow = 53;
  static const int daysPerWeek = 7;
  static const int totalDays = weeksToShow * daysPerWeek;

  /// Builds the last weeksToShow weeks (Sun–Sat rows) of heatmap cells
  /// from rollups ('YYYY-MM-DD' -> seconds). Any date in range with no
  /// matching entry — including the gap between the last logged day and
  /// today — resolves to 0 seconds. Dates after now] are HeatmapDay.isFuture
  /// and always carry 0 seconds.
  static List<HeatmapDay> buildGrid(Map<String, int> rollups, {DateTime? now}) {
    final today = _dateOnly(now ?? DateTime.now());
    final firstVisibleDate = _startOfWeek(today)
        .subtract(const Duration(days: (weeksToShow - 1) * daysPerWeek));

    return List.generate(totalDays, (index) {
      final date = firstVisibleDate.add(Duration(days: index));
      final isFuture = date.isAfter(today);
      final seconds = isFuture
          ? 0
          : (rollups[DailyRollupDateUtils.format(date)] ?? 0);
      return HeatmapDay(
        date: date,
        durationSeconds: seconds,
        isFuture: isFuture,
      );
    });
  }

  /// Month label for the column starting at columnStart, or null when
  /// this column isn't the start of a month (only the week containing a
  /// month's first 7 days gets a label).
  static String? monthLabelForColumn(DateTime columnStart) {
    if (columnStart.day > 7) return null;
    return DailyRollupDateUtils.monthNames[columnStart.month - 1];
  }

  static DateTime _dateOnly(DateTime date) =>
      DateTime(date.year, date.month, date.day);

  /// Sunday is the first row in the grid.
  static DateTime _startOfWeek(DateTime date) {
    const sundayIndex = DateTime.sunday;
    final diff = (date.weekday + daysPerWeek - sundayIndex) % daysPerWeek;
    return date.subtract(Duration(days: diff));
  }
}
