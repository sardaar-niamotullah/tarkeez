import 'package:tarkeez/core/utils/rollup_date_utils.dart';

class LiveSessionSlices {
  LiveSessionSlices._();

  /// Splits a running session at local midnight, like the DB triggers do for a
  /// saved one. Returns 'YYYY-MM-DD' -> whole seconds (empty under 1 second).
  static Map<String, int> split(DateTime startedAt, DateTime now) {
    final slices = <String, int>{};
    var cursor = startedAt.toLocal();
    while (cursor.isBefore(now)) {
      final midnight = DateTime(cursor.year, cursor.month, cursor.day + 1);
      final end = midnight.isBefore(now) ? midnight : now;
      final seconds = end.difference(cursor).inSeconds;
      if (seconds > 0) slices[RollupDateUtils.format(cursor)] = seconds;
      cursor = end;
    }
    return slices;
  }
}