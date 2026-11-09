enum TrackingMode {
  linear(isLocked: false),
  pomodoro(isLocked: true);

  const TrackingMode({this.isLocked = false});

  final bool isLocked;
}

enum AppThemeColor {
  green(isLocked: false),
  purple(isLocked: false),
  pink(isLocked: false),
  blue(isLocked: false);

  const AppThemeColor({this.isLocked = false});

  final bool isLocked;
}

enum PeriodRange {
  // left column
  today('Today'),
  thisWeek('This week'),
  last3Days('Last 3 days'),
  last7Days('Last 7 days', isLocked: true),
  thisMonth('This month', isLocked: true),
  thisYear('This year', isLocked: true),
  last12Months('Last 12 months', isLocked: true),
  // right column
  yesterday('Yesterday'),
  lastWeek('Last week'),
  last5Days('Last 5 days'),
  last30Days('Last 30 days', isLocked: true),
  lastMonth('Last month', isLocked: true),
  lastYear('Last year', isLocked: true),
  allTime('All time', isLocked: true);

  // ignore: unused_element_parameter
  const new(this.label, {this.isLocked = false});

  final String label;
  final bool isLocked;
}
