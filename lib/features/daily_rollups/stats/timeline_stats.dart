import 'package:tarkeez/features/daily_rollups/utils/daily_rollup_date_utils.dart';
import 'package:tarkeez/features/report/data/model/timeline_model.dart';

class TimelineStats {
  TimelineStats._();

  /// Builds the last days calendar days (oldest first, today last) as
  /// TimelineModel entries. Any date with no rollup entry resolves to 0
  /// seconds — matches how HeatmapStats/InvestedTimeStats treat gaps.
  static List<TimelineModel> recentDays(
    Map<String, int> rollups, {
    int days = 7,
    DateTime? now,
  }) {
    final todayKey = DailyRollupDateUtils.format(now ?? DateTime.now());
    return List.generate(days, (index) {
      final dateKey = DailyRollupDateUtils.shiftDate(
        todayKey,
        -(days - 1 - index),
      );
      return TimelineModel(
        date: DateTime.parse(dateKey),
        seconds: rollups[dateKey] ?? 0,
      );
    });
  }
}
