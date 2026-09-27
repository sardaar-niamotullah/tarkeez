import 'package:tarkeez/core/shared_files/enums/report_period.dart';

extension ReportPeriodRange on ReportPeriod {
  /// Inclusive local-day range [start, end] this period covers, both
  /// truncated to midnight. Returns null for ReportPeriod.allTime
  /// (signals "no filtering — use every record").
  (DateTime start, DateTime end)? dateRange({DateTime? now}) {
    final today = _dateOnly(now ?? DateTime.now());

    switch (this) {
      case ReportPeriod.today:
        return (today, today);
      case ReportPeriod.yesterday:
        final y = today.subtract(const Duration(days: 1));
        return (y, y);
      case ReportPeriod.last3Days:
        return (today.subtract(const Duration(days: 2)), today);
      case ReportPeriod.last5Days:
        return (today.subtract(const Duration(days: 4)), today);
      case ReportPeriod.this7Days:
        return (today.subtract(const Duration(days: 6)), today);
      case ReportPeriod.last30Days:
        return (today.subtract(const Duration(days: 29)), today);
      case ReportPeriod.thisWeek:
        return (_startOfIsoWeek(today), today);
      case ReportPeriod.lastWeek:
        final thisWeekStart = _startOfIsoWeek(today);
        final lastWeekEnd = thisWeekStart.subtract(const Duration(days: 1));
        final lastWeekStart = lastWeekEnd.subtract(const Duration(days: 6));
        return (lastWeekStart, lastWeekEnd);
      case ReportPeriod.thisMonth:
        return (DateTime(today.year, today.month, 1), today);
      case ReportPeriod.lastMonth:
        final thisMonthStart = DateTime(today.year, today.month, 1);
        final lastMonthEnd = thisMonthStart.subtract(const Duration(days: 1));
        final lastMonthStart = DateTime(
          lastMonthEnd.year,
          lastMonthEnd.month,
          1,
        );
        return (lastMonthStart, lastMonthEnd);
      case ReportPeriod.thisYear:
        return (DateTime(today.year, 1, 1), today);
      case ReportPeriod.lastYear:
        return (
          DateTime(today.year - 1, 1, 1),
          DateTime(today.year - 1, 12, 31),
        );
      case ReportPeriod.last12Months:
        // Dart's DateTime constructor normalizes a negative/underflowed
        // month by rolling the year back, so this is safe across Jan.
        return (DateTime(today.year, today.month - 11, 1), today);
      case ReportPeriod.allTime:
        return null;
    }
  }

  static DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

  /// Monday = 1 .. Sunday = 7 (ISO week).
  static DateTime _startOfIsoWeek(DateTime date) =>
      date.subtract(Duration(days: date.weekday - 1));
}
