import 'package:tarkeez/core/extensions/period_range_extension.dart';
import 'package:tarkeez/core/shared_files/enums/period_range.dart';
import 'package:tarkeez/core/utils/rollup_date_utils.dart';
import 'package:tarkeez/features/daily_rollups/data/models/timeline_model.dart';

class TimelineStats {
  TimelineStats._();

  static List<TimelineModel> timelineForPeriod(
    Map<String, int> rollups,
    PeriodRange period, {
    DateTime? now,
  }) {
    final n = now ?? DateTime.now();
    final today = DateTime(n.year, n.month, n.day);
    final range = period.dateRange(now: now);
    final DateTime start;
    final DateTime end;
    if (range != null) {
      (start, end) = range;
    } else {
      start = _earliestDate(rollups) ?? today;
      end = today;
    }
    final dayCount =
        DateTime.utc(
          end.year,
          end.month,
          end.day,
        ).difference(DateTime.utc(start.year, start.month, start.day)).inDays +
        1;
    return List.generate(dayCount, (index) {
      final date = DateTime(end.year, end.month, end.day - index);
      return TimelineModel(
        date: date,
        seconds: rollups[RollupDateUtils.format(date)] ?? 0,
      );
    });
  }

  static DateTime? _earliestDate(Map<String, int> rollups) {
    if (rollups.isEmpty) return null;
    final first = rollups.keys.reduce((a, b) => a.compareTo(b) <= 0 ? a : b);
    return DateTime.parse(first);
  }
}
