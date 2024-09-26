// given a habit list of complition days
// is habit complited today

import 'package:habit_tracker_app/models/habit.dart';

bool isHabitCompletedToday(List<DateTime> completedDays) {
  final today = DateTime.now();
  return completedDays.any(
    (date) =>
        date.year == today.year &&
        date.month == today.month &&
        date.day == today.day,
  );
}

// prepare heat map dataset
Map<DateTime, int> prepHeatMapDataset(List<Habit> habits) {
  Map<DateTime, int> dataset = {};
  for (var habit in habits) {
    for (var date in habit.completedDays) {
      // normalize date to avoid mismatch
      final normalizeDate = DateTime(date.year, date.month, date.day);

      // if data already exists in dataset, inrease it count
      if (dataset.containsKey(normalizeDate)) {
        dataset[normalizeDate] = dataset[normalizeDate]! + 1;
      } else {
        dataset[normalizeDate] = 1;
      }
    }
  }
  return dataset;
}
