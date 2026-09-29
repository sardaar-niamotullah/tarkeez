enum PeriodRange {
  today('Today'),
  lastMonth('Last month'),
  yesterday('Yesterday'),
  thisYear('This year'),
  last3Days('Last 3 days'),
  lastYear('Last year'),
  last5Days('Last 5 days'),
  last7Days('Last 7 days'),
  thisWeek('This week'),
  last30Days('Last 30 days'),
  lastWeek('Last week'),
  last12Months('Last 12 months'),
  thisMonth('This month'),
  allTime('All time');

  // ignore: unused_element_parameter
  const PeriodRange(this.label, {this.isLocked = false});

  final String label;
  final bool isLocked;
}
