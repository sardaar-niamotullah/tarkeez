import 'package:tarkeez/core/shared_files/enums/period_range.dart';

extension PeriodRangeExtension on PeriodRange {
  (DateTime start, DateTime end)? dateRange({DateTime? now}) {
    final today = _dateOnly(now ?? DateTime.now());

    switch (this) {
      case PeriodRange.today:
        return (today, today);
      case PeriodRange.yesterday:
        final y = today.subtract(const Duration(days: 1));
        return (y, y);
      case PeriodRange.last3Days:
        return (today.subtract(const Duration(days: 2)), today);
      case PeriodRange.last5Days:
        return (today.subtract(const Duration(days: 4)), today);
      case PeriodRange.last7Days:
        return (today.subtract(const Duration(days: 6)), today);
      case PeriodRange.last30Days:
        return (today.subtract(const Duration(days: 29)), today);
      case PeriodRange.thisWeek:
        return (_startOfIsoWeek(today), today);
      case PeriodRange.lastWeek:
        final thisWeekStart = _startOfIsoWeek(today);
        final lastWeekEnd = thisWeekStart.subtract(const Duration(days: 1));
        final lastWeekStart = lastWeekEnd.subtract(const Duration(days: 6));
        return (lastWeekStart, lastWeekEnd);
      case PeriodRange.thisMonth:
        return (DateTime(today.year, today.month, 1), today);
      case PeriodRange.lastMonth:
        final thisMonthStart = DateTime(today.year, today.month, 1);
        final lastMonthEnd = thisMonthStart.subtract(const Duration(days: 1));
        final lastMonthStart = DateTime(
          lastMonthEnd.year,
          lastMonthEnd.month,
          1,
        );
        return (lastMonthStart, lastMonthEnd);
      case PeriodRange.thisYear:
        return (DateTime(today.year, 1, 1), today);
      case PeriodRange.lastYear:
        return (
          DateTime(today.year - 1, 1, 1),
          DateTime(today.year - 1, 12, 31),
        );
      case PeriodRange.last12Months:
        return (DateTime(today.year, today.month - 11, 1), today);
      case PeriodRange.allTime:
        return null;
    }
  }

  static DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

  /// Monday = 1 .. Sunday = 7 (ISO week).
  static DateTime _startOfIsoWeek(DateTime date) =>
      date.subtract(Duration(days: date.weekday - 1));
}
