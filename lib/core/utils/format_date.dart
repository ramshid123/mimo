import 'package:intl/intl.dart';

String formatDate(DateTime date) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final tomorrow = today.add(const Duration(days: 1));

  if (date.year == today.year &&
      date.month == today.month &&
      date.day == today.day) {
    return 'Today';
  } else if (date.year == tomorrow.year &&
      date.month == tomorrow.month &&
      date.day == tomorrow.day) {
    return 'Tomorrow';
  } else {
    // Format the date as 'Friday, Oct 04, 2024'
    return DateFormat('EEEE, MMM dd, yyyy').format(date);
  }
}
