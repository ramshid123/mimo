import 'package:intl/intl.dart';
import 'package:mimo/core/entity/task_entity.dart';

/// Function to group and sort tasks by date
Map<String, List<TaskEntity>> groupTasksByDateAndSort(List<TaskEntity> tasks) {
  final Map<String, List<TaskEntity>> groupedTasks = {};

  // Get today's and tomorrow's dates for comparison
  final DateTime now = DateTime.now();
  final DateTime today = DateTime(now.year, now.month, now.day);
  final DateTime tomorrow = today.add(Duration(days: 1));

  // Group tasks
  for (var task in tasks) {
    final DateTime taskDate =
        DateTime(task.taskDate.year, task.taskDate.month, task.taskDate.day);

    // Skip tasks before today
    if (taskDate.isBefore(today)) {
      continue;
    }

    // Determine the date label
    String dateLabel;
    if (taskDate == today) {
      dateLabel = "Today";
    } else if (taskDate == tomorrow) {
      dateLabel = "Tomorrow";
    } else {
      dateLabel = DateFormat('EEEE, MMM dd, yyyy').format(taskDate);
    }

    // Add task to the appropriate group
    if (!groupedTasks.containsKey(dateLabel)) {
      groupedTasks[dateLabel] = [];
    }
    groupedTasks[dateLabel]!.add(task);
  }

  // Sort the grouped keys in chronological order
  final sortedKeys = groupedTasks.keys.toList()
    ..sort((a, b) {
      // Handle "Today" and "Tomorrow" explicitly
      if (a == "Today") return -1; // Today comes first
      if (b == "Today") return 1;
      if (a == "Tomorrow") return -1; // Tomorrow comes after Today
      if (b == "Tomorrow") return 1;

      // Parse the remaining keys as dates and compare them
      final dateA = DateFormat('EEEE, MMM dd, yyyy').parse(a);
      final dateB = DateFormat('EEEE, MMM dd, yyyy').parse(b);
      return dateA.compareTo(dateB);
    });

  // Create a sorted map
  final Map<String, List<TaskEntity>> sortedGroupedTasks = {
    for (var key in sortedKeys) key: groupedTasks[key]!,
  };

  return sortedGroupedTasks;
}
