import 'package:intl/intl.dart';

class DateFormatter {
  static String readableDate(DateTime date) =>
      DateFormat('d MMM, yyyy').format(date);
  static String readableTime(DateTime date) =>
      DateFormat('hh:mma').format(date).toLowerCase();
  static String readableDateTime(DateTime date) =>
      DateFormat('hh:mma · d MMM, yy').format(date).toLowerCase();
  static int durationInSeconds({
    required DateTime startedAt,
    required DateTime endedAt,
  }) => endedAt.difference(startedAt).inSeconds;

  static String weekdayName(DateTime date) => DateFormat('EEEE').format(date);

  static String elapsedTime(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inDays > 0) {
      return diff.inDays == 1 ? '1 day ago' : '${diff.inDays} days ago';
    }
    if (diff.inHours > 0) {
      return diff.inHours == 1 ? '1 hour ago' : '${diff.inHours} hours ago';
    }
    if (diff.inMinutes > 0) {
      return diff.inMinutes == 1
          ? '1 minute ago'
          : '${diff.inMinutes} minutes ago';
    }
    return 'just now';
  }

  static String formatDurationMinutes(int minutes) {
    final hours = minutes ~/ 60;
    final remainingMinutes = minutes % 60;

    if (hours == 0) return '${remainingMinutes}m';
    if (remainingMinutes == 0) return '${hours}h';

    return '${hours}h ${remainingMinutes}m';
  }
}
