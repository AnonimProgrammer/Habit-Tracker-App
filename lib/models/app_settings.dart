import 'package:isar/isar.dart';

// cmd: dart run build_runner build
part 'app_settings.g.dart';

@Collection()
class AppSettings {
  Id id = Isar.autoIncrement;
  DateTime? firstlLaunchDate;
}
