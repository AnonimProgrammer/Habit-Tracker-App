import 'package:flutter/material.dart';
import 'package:habit_tracker_app/models/app_settings.dart';
import 'package:habit_tracker_app/models/habit.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class HabitDatabase extends ChangeNotifier {
  static late Isar isar;

  // setup

  // initialize - Data Base
  static Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open(
      [HabitSchema, AppSettingsSchema],
      directory: dir.path,
    );
  }

  // save first date of app startup
  Future<void> saveFirstLaunchDate() async {
    final existingSettings = await isar.appSettings.where().findFirst();

    if (existingSettings == null) {
      final settings = AppSettings()..firstlLaunchDate = DateTime.now();
      await isar.writeTxn(() => isar.appSettings.put(settings));
    }
  }

  // get first date of app startup
  Future<DateTime?> getFirstLaunchDate() async {
    final settings = await isar.appSettings.where().findFirst();
    return settings?.firstlLaunchDate;
  }
  // C R U D - operations

  // list of habits
  List<Habit> currentHabits = [];
  // create
  Future<void> addHabit(String habitName) async {
    // create a new habit
    final newHabit = Habit()..name = habitName;
    // save to db
    await isar.writeTxn(() => isar.habits.put(newHabit));
    // re-read from db
    readHabits();
  }

  // read
  Future<void> readHabits() async {
    // fetch all habits
    List<Habit> fetchedHabits = await isar.habits.where().findAll();
    currentHabits.clear();
    currentHabits.addAll(fetchedHabits);

    // update UI
    notifyListeners();
  }

  // update - on/off
  Future<void> updateHabitComplition(int id, bool isCompleted) async {
    // find habit
    final habit = await isar.habits.get(id);
    // update status
    if (habit != null) {
      await isar.writeTxn(() async {
        if (isCompleted && !habit.completedDays.contains(DateTime.now())) {
          // today
          final today = DateTime.now();
          habit.completedDays.add(
            DateTime(
              today.year,
              today.month,
              today.day,
            ),
          );
        } else {
          habit.completedDays.removeWhere(
            (date) =>
                date.year == DateTime.now().year &&
                date.month == DateTime.now().month &&
                date.day == DateTime.now().day,
          );
        }
        // save updated habits
        await isar.habits.put(habit);
      });
    }
    // re-read
    readHabits();
  }

  // uodate - name
  Future<void> updateHabitName(int id, String newName) async {
    // find the specific habit
    final habit = await isar.habits.get(id);
    // update habit name
    if (habit != null) {
      await isar.writeTxn(() async {
        habit.name = newName;
        await isar.habits.put(habit);
      });
    }
    // re-read
    readHabits();
  }

  // delete
  Future<void> deleteHabit(int id) async {
    await isar.writeTxn(() async {
      await isar.habits.delete(id);
    });
    // re-read
    readHabits();
  }
}
