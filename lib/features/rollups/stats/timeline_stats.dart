import 'package:tarkeez/features/rollups/data/models/timeline_model.dart';
import 'package:tarkeez/features/rollups/utils/daily_rollup_date_utils.dart';

class TimelineStats {
  TimelineStats._();
  
  static List<TimelineModel> timeline(
    Map<String, int> rollups, {
    int days = 7,
    DateTime? now,
  }) {
    final todayKey = DailyRollupDateUtils.format(now ?? DateTime.now());

    return List.generate(days, (index) {
      final dateKey = DailyRollupDateUtils.shiftDate(todayKey, -index);

      return TimelineModel(
        date: DateTime.parse(dateKey),
        seconds: rollups[dateKey] ?? 0,
      );
    });
  }
}
