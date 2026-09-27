enum ReportPeriod {
  today('Today'),
  lastMonth('Last month', isLocked: true),
  yesterday('Yesterday'),
  thisYear('This year', isLocked: true),
  last3Days('Last 3 days'),
  lastYear('Last year', isLocked: true),
  last5Days('Last 5 days'),
  last7Days('Last 7 days', isLocked: true),
  thisWeek('This week'),
  last30Days('Last 30 days', isLocked: true),
  lastWeek('Last week'),
  last12Months('Last 12 months', isLocked: true),
  thisMonth('This month'),
  allTime('All time', isLocked: true);

  const ReportPeriod(this.label, {this.isLocked = false});

  final String label;
  final bool isLocked;
}
