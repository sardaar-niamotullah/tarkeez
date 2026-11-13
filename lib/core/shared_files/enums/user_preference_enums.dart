enum ChartType {
  bar('Bar chart'),
  line('Line chart', isPremium: true);

  const new(this.label, {this.isPremium = false});

  final String label;
  final bool isPremium;
}

enum TrackingMode {
  linear,
  pomodoro(isPremium: true);

  const TrackingMode({this.isPremium = false});

  final bool isPremium;
}

enum AppThemeColor {
  green,
  purple(isPremium: true),
  pink(isPremium: true),
  blue(isPremium: true);

  const AppThemeColor({this.isPremium = false});

  final bool isPremium;
}

enum PeriodRange {
  // left column
  today('Today'),
  thisWeek('This week'),
  last3Days('Last 3 days'),
  last7Days('Last 7 days', isPremium: true),
  thisMonth('This month', isPremium: true),
  thisYear('This year', isPremium: true),
  last12Months('Last 12 months', isPremium: true),
  // right column
  yesterday('Yesterday'),
  lastWeek('Last week'),
  last5Days('Last 5 days'),
  last30Days('Last 30 days', isPremium: true),
  lastMonth('Last month', isPremium: true),
  lastYear('Last year', isPremium: true),
  allTime('All time', isPremium: true);

  const new(this.label, {this.isPremium = false});

  final String label;
  final bool isPremium;
}
