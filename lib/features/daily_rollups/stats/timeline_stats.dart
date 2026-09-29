import 'package:tarkeez/core/utils/rollup_date_utils.dart';
import 'package:tarkeez/features/daily_rollups/data/models/timeline_model.dart';

class TimelineStats {
  TimelineStats._();
  
  static List<TimelineModel> timeline(
    Map<String, int> rollups, {
    int days = 7,
    DateTime? now,
  }) {
    final todayKey = RollupDateUtils.format(now ?? DateTime.now());

    return List.generate(days, (index) {
      final dateKey = RollupDateUtils.shiftDate(todayKey, -index);

      return TimelineModel(
        date: DateTime.parse(dateKey),
        seconds: rollups[dateKey] ?? 0,
      );
    });
  }
}
