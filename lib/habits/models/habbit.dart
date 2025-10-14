import 'package:isar/isar.dart';

// run cmd to generate file: dart run build_runner build
part 'habbit.g.dart';

@Collection()
class Habit {
  // habbit id
  Id id = Isar.autoIncrement;

  // habit name
  late String name;

  // completed days
  List<DateTime> completedDays = [
    // DateTime(year, month, day),
    // DateTime(2025, 1, 1),
    // DateTime(2025, 1, 2),
  ];
}
