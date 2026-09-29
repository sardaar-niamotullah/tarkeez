enum PeriodRange {
  // left column
  today('Today'),
  thisWeek('This week'),
  thisMonth('This month'),
  thisYear('This year'),
  last3Days('Last 3 days'),
  last7Days('Last 7 days'),
  last12Months('Last 12 months'),
  // right column
  yesterday('Yesterday'),
  lastWeek('Last week'),
  lastMonth('Last month'),
  lastYear('Last year'),
  last5Days('Last 5 days'),
  last30Days('Last 30 days'),
  allTime('All time');

  // ignore: unused_element_parameter
  const PeriodRange(this.label, {this.isLocked = false});

  final String label;
  final bool isLocked;
}
