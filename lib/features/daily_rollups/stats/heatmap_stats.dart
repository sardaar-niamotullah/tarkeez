import 'package:tarkeez/core/utils/rollup_date_utils.dart';
import 'package:tarkeez/features/daily_rollups/data/models/heatmap_day.dart';

class HeatmapStats {
  HeatmapStats._();

  static const int weeksToShow = 52;
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
          : (rollups[RollupDateUtils.format(date)] ?? 0);
      return HeatmapDay(
        date: date,
        durationSeconds: seconds,
        isFuture: isFuture,
      );
    });
  }

  /// The last 12 months, oldest first, ending with the current month.
  /// In November: Dec, Jan, ... Nov.
  static List<String> monthLabels({DateTime? now}) {
    final month = (now ?? DateTime.now()).month;
    return [
      for (var i = 0; i < 12; i++) RollupDateUtils.monthNames[(month + i) % 12],
    ];
  }

  static DateTime _dateOnly(DateTime date) =>
      DateTime(date.year, date.month, date.day);

  /// Monday is the first row in the grid.
  static DateTime _startOfWeek(DateTime date) =>
      date.subtract(Duration(days: date.weekday - DateTime.monday));
}
