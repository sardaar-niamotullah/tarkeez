class PersonalBestPeriod {
  const PersonalBestPeriod({required this.seconds, required this.label});
  final int seconds;
  final String label;

  static const empty = PersonalBestPeriod(seconds: 0, label: '—');
}
