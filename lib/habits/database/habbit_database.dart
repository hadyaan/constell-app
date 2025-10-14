import 'package:flutter/material.dart';
import 'package:note_app/habits/models/habbit.dart';
import 'package:note_app/habits/models/app_settings.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class HabbitDatabase extends ChangeNotifier {
  static Isar? _isar;

  static Future<void> initialize() async {
    if (_isar != null && _isar!.isOpen) return;

    final dir = await getApplicationDocumentsDirectory();
    _isar = await Isar.open(
      [HabitSchema, AppSettingsSchema],
      directory: dir.path,
      name: 'habbit_db', // nama db habbit
    );
  }

  static Isar get isar => _isar!;

    // Simpan tanggal pertama kali app dibuka (untuk heatmap)
  Future<void> saveFirstLaunchDate() async {
    final existingSettings = await isar.appSettings.where().findFirst();
    if (existingSettings == null) {
      final settings = AppSettings()..firstLaunchDate = DateTime.now();
      await isar.writeTxn(() => isar.appSettings.put(settings));
    }
  }

  // Ambil tanggal pertama kali app dibuka (untuk heatmap)
  Future<DateTime?> getFirstLaunchDate() async {
    final settings = await isar.appSettings.where().findFirst();
    return settings?.firstLaunchDate;
  }


  final List<Habit> currentHabits = [];

  Future<void> addHabit(String habitName) async {
    final newHabit = Habit()..name = habitName;
    await isar.writeTxn(() => isar.habits.put(newHabit));
    await readHabits();
    notifyListeners(); // penting
  }

  Future<void> readHabits() async {
    final fetchedHabits = await isar.habits.where().findAll();
    currentHabits
      ..clear()
      ..addAll(fetchedHabits);
    notifyListeners();
  }

  Future<void> updateHabitCompletion(int id, bool isCompleted) async {
    final habit = await isar.habits.get(id);
    if (habit != null) {
      await isar.writeTxn(() async {
        final today = DateTime.now();
        final todayDate = DateTime(today.year, today.month, today.day);

        if (isCompleted && !habit.completedDays.contains(todayDate)) {
          habit.completedDays.add(todayDate);
        } else {
          habit.completedDays.removeWhere(
            (date) =>
                date.year == today.year &&
                date.month == today.month &&
                date.day == today.day,
          );
        }

        await isar.habits.put(habit);
      });
    }
    await readHabits();
  }

  Future<void> updateHabitName(int id, String newName) async {
    final habit = await isar.habits.get(id);
    if (habit != null) {
      await isar.writeTxn(() async {
        habit.name = newName;
        await isar.habits.put(habit);
      });
    }
    await readHabits();
  }

  Future<void> deleteHabit(int id) async {
    await isar.writeTxn(() async {
      await isar.habits.delete(id);
    });
    await readHabits();
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:note_app/habits/models/habbit.dart';
// import 'package:note_app/habits/models/app_settings.dart';
// import 'package:isar/isar.dart';
// import 'package:path_provider/path_provider.dart';

// class HabbitDatabase extends ChangeNotifier {
//   static Isar? _isar;

//   /*
//   S E T U P
//   */

//   // I N I T I A L I Z E - D A T A B A S E
//   static Future<void> initialize() async {
//     // Jika sudah terbuka, jangan buka lagi
//     if (_isar != null && _isar!.isOpen) return;

//     final dir = await getApplicationDocumentsDirectory();
//     _isar = await Isar.open(
//       [
//         HabitSchema,
//         AppSettingsSchema,
//       ],
//       directory: dir.path,
//     );
//   }

//   // Getter biar gampang akses instance dari luar
//   static Isar get isar => _isar!;

//   // Save first date of app startup (for heatmap)
//   Future<void> saveFirstLaunchDate() async {
//     final existingSettings = await isar.appSettings.where().findFirst();
//     if (existingSettings == null) {
//       final settings = AppSettings()..firstLaunchDate = DateTime.now();
//       await isar.writeTxn(() => isar.appSettings.put(settings));
//     }
//   }

//   // Get first date of app startup (for heatmap)
//   Future<DateTime?> getFirstLaunchDate() async {
//     final settings = await isar.appSettings.where().findFirst();
//     return settings?.firstLaunchDate;
//   }

//   /*
//   C R U D X O P E R A T I O N S
//   */

//   // List of habits
//   final List<Habit> currentHabits = [];

//   // C R E A T E  - add a new habit
//   Future<void> addHabit(String habitName) async {
//     final newHabit = Habit()..name = habitName;
//     await isar.writeTxn(() => isar.habits.put(newHabit));
//     readHabits();
//   }

//   // R E A D - read saved habits from db
//   Future<void> readHabits() async {
//     List<Habit> fetchedHabits = await isar.habits.where().findAll();
//     currentHabits
//       ..clear()
//       ..addAll(fetchedHabits);
//     notifyListeners();
//   }

//   // U P D A T E - check habit on and off
//   Future<void> updateHabitCompletion(int id, bool isCompleted) async {
//     final habit = await isar.habits.get(id);
//     if (habit != null) {
//       await isar.writeTxn(() async {
//         final today = DateTime.now();
//         final todayDate = DateTime(today.year, today.month, today.day);

//         if (isCompleted && !habit.completedDays.contains(todayDate)) {
//           habit.completedDays.add(todayDate);
//         } else {
//           habit.completedDays.removeWhere(
//             (date) =>
//                 date.year == today.year &&
//                 date.month == today.month &&
//                 date.day == today.day,
//           );
//         }

//         await isar.habits.put(habit);
//       });
//     }
//     readHabits();
//   }

//   // U P D A T E - edit habit name
//   Future<void> updateHabitName(int id, String newName) async {
//     final habit = await isar.habits.get(id);
//     if (habit != null) {
//       await isar.writeTxn(() async {
//         habit.name = newName;
//         await isar.habits.put(habit);
//       });
//     }
//     readHabits();
//   }

//   // D E L E T E - delete habit
//   Future<void> deleteHabit(int id) async {
//     await isar.writeTxn(() async {
//       await isar.habits.delete(id);
//     });
//     readHabits();
//   }
// }
