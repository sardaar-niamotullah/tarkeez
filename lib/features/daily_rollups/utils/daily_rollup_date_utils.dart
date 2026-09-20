class DailyRollupDateUtils {
  DailyRollupDateUtils._();

  static String todayLocal() => format(DateTime.now());

  static String format(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  static String shiftDate(String date, int deltaDays) {
    final d = DateTime.parse(date).add(Duration(days: deltaDays));
    return format(d);
  }

  static const monthNames = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  /// '2026-09-01' -> '1 Sep, 2026'
  static String formatDayLabel(String date) {
    final d = DateTime.parse(date);
    return '${d.day} ${monthNames[d.month - 1]}, ${d.year}';
  }

  /// '2026-09' -> 'Sep, 2026'
  static String formatMonthLabel(String monthKey) {
    final parts = monthKey.split('-');
    final year = parts[0];
    final month = int.parse(parts[1]);
    return '${monthNames[month - 1]}, $year';
  }

  /// Returns ISO 8601 week key ('YYYY-Www') for a 'YYYY-MM-DD' date.
  /// ISO weeks start Monday; week 1 is the week containing the year's
  /// first Thursday (equivalently, containing Jan 4th).
  static String isoWeekKey(String date) {
    final d = DateTime.parse(date);
    final weekday = d.weekday; // Mon=1 ... Sun=7
    final thursday = d.add(Duration(days: 4 - weekday));
    final isoYear = thursday.year;

    final jan4 = DateTime(isoYear, 1, 4);
    final week1Monday = jan4.subtract(Duration(days: jan4.weekday - 1));

    final diffDays = thursday
        .add(const Duration(days: -3))
        .difference(week1Monday)
        .inDays;
    final isoWeek = (diffDays / 7).floor() + 1;

    return '$isoYear-W${isoWeek.toString().padLeft(2, '0')}';
  }
}
