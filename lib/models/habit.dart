import 'package:isar/isar.dart';

// cmd: dart run build_runner build
part 'habit.g.dart';

@Collection()
class Habit {
  // habit id
  Id id = Isar.autoIncrement;
  // habit name
  late String name;

  // completed day
  List<DateTime> completedDays = [
    // DateTime(year, month, day)
  ];
}
