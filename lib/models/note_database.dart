import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'note.dart';

class NoteDatabase extends ChangeNotifier {
  static Isar? _isar;

  // I N I T I A L I Z E - D A T A B A S E
  static Future<void> initialize() async {
    if (_isar != null && _isar!.isOpen) return;

    final dir = await getApplicationDocumentsDirectory();
    _isar = await Isar.open(
      [NoteSchema],
      directory: dir.path,
      name: 'note_db', // nama db note app
    );
  }

  static Isar get isar => _isar!;

  // list of notes
  final List<Note> currentNotes = [];

  // C R E A T E - a note and save to db
  Future<void> addNote(String title, String text) async {
    final newNote = Note()
      ..title = title
      ..text = text;

    await isar.writeTxn(() => isar.notes.put(newNote));
    await fetchNotes();
    notifyListeners(); // penting
  }

  // U P D A T E - a note in db
  Future<void> updateNote(int id, String title, String text) async {
    final existingNote = await isar.notes.get(id);
    if (existingNote != null) {
      existingNote
        ..title = title
        ..text = text;

      await isar.writeTxn(() => isar.notes.put(existingNote));
      await fetchNotes();
      notifyListeners();
    }
  }

  // R E A D - notes from db
  Future<void> fetchNotes() async {
    final fetchedNotes = await isar.notes.where().findAll();
    currentNotes
      ..clear()
      ..addAll(fetchedNotes);
    notifyListeners();
  }

  // D E L E T E - a note from the db
  Future<void> deleteNote(int id) async {
    await isar.writeTxn(() => isar.notes.delete(id));
    await fetchNotes();
    notifyListeners();
  }
}

// import 'package:flutter/material.dart';
// import 'package:isar/isar.dart';
// import 'package:path_provider/path_provider.dart';

// import 'note.dart';

// class NoteDatabase extends ChangeNotifier {
//   static late Isar isar;

//   // I N I T I A L I Z E - D A T A B A S E
//   static Future<void> initialize() async {
//     final dir = await getApplicationDocumentsDirectory();
//     isar = await Isar.open([NoteSchema], directory: dir.path, name: 'note_db',);
//   }

//   // list of notes
//   final List<Note> currentNotes = [];

//   // C R E A T E - a note and save to db
//   Future<void> addNote(String title, String text) async {
//     final newNote = Note()
//       ..title = title
//       ..text = text;

//     await isar!.writeTxn(() async {
//       await isar!.notes.put(newNote);
//     });

//     await fetchNotes();
//   }

//   // U P D A T E - a note in db
//   Future<void> updateNote(int id, String title, String text) async {
//     final existingNote = await isar!.notes.get(id);
//     if (existingNote != null) {
//       existingNote.title = title;
//       existingNote.text = text;

//       await isar!.writeTxn(() async {
//         await isar!.notes.put(existingNote);
//       });

//       await fetchNotes();
//     }
//   }

//   // R E A D - notes from db
//   Future<void> fetchNotes() async {
//     List<Note> fetchedNotes = await isar.notes.where().findAll();
//     currentNotes.clear();
//     currentNotes.addAll(fetchedNotes);
//     notifyListeners();
//   }

//   // Future<void> updateNote(int id, String newText) async {
//   //   final existingNote = await isar.notes.get(id);
//   //   if (existingNote != null) {
//   //     existingNote.text = newText;
//   //     await isar.writeTxn(() => isar.notes.put(existingNote));
//   //     await fetchNotes();
//   //   }
//   // }

//   // D E L E T E - a note from the db
//   Future<void> deleteNote(int id) async {
//     await isar.writeTxn(() => isar.notes.delete(id));
//     await fetchNotes();
//   }
// }
