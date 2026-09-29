
import 'package:tarkeez/features/rollups/data/models/personal_best_period.dart';
import 'package:tarkeez/features/rollups/utils/daily_rollup_date_utils.dart';

class PersonalBestStats {
  PersonalBestStats._();

  static PersonalBestPeriod bestDay(Map<String, int> rollups) {
    if (rollups.isEmpty) return PersonalBestPeriod(label: 'Day', seconds: 0);

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
    if (rollups.isEmpty) return PersonalBestPeriod(label: 'Week', seconds: 0);

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
    if (rollups.isEmpty) return PersonalBestPeriod(label: 'Month', seconds: 0);

    final byMonth = <String, int>{};
    rollups.forEach((date, seconds) {
      final key = date.substring(0, 7);
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
    if (rollups.isEmpty) return PersonalBestPeriod(label: 'Year', seconds: 0);

    final byYear = <String, int>{};
    rollups.forEach((date, seconds) {
      final key = date.substring(0, 4);
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
