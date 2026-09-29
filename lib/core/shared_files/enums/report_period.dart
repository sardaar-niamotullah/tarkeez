enum ReportPeriod {
  today('Today'),
  lastMonth('Last month', isLocked: false),
  yesterday('Yesterday'),
  thisYear('This year', isLocked: false),
  last3Days('Last 3 days'),
  lastYear('Last year', isLocked: false),
  last5Days('Last 5 days'),
  last7Days('Last 7 days', isLocked: false),
  thisWeek('This week'),
  last30Days('Last 30 days', isLocked: false),
  lastWeek('Last week'),
  last12Months('Last 12 months', isLocked: false),
  thisMonth('This month'),
  allTime('All time', isLocked: false);

  const ReportPeriod(this.label, {this.isLocked = false});

  final String label;
  final bool isLocked;
}
