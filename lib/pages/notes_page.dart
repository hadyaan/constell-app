import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:note_app/components/drawer.dart';
import 'package:note_app/components/note_tile.dart';
import 'package:note_app/models/note.dart';
import 'package:note_app/models/note_database.dart';
import 'package:note_app/pages/add_or_edit_note_page.dart';
import 'package:note_app/pages/read_note_page.dart';
import 'package:provider/provider.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  final textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    readNotes();
  }

  // READ NOTES
  void readNotes() {
    context.read<NoteDatabase>().fetchNotes();
  }

  // CREATE NOTE (SLIDE FROM RIGHT)
  void createNote() {
    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 400),
        pageBuilder: (context, animation, secondaryAnimation) =>
            const AddOrEditNotePage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final newPageAnimation =
              Tween<Offset>(
                begin: const Offset(1.0, 0.0),
                end: Offset.zero,
              ).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeInOut),
              );

          final oldPageAnimation =
              Tween<Offset>(
                begin: Offset.zero,
                end: const Offset(-0.3, 0.0),
              ).animate(
                CurvedAnimation(
                  parent: secondaryAnimation,
                  curve: Curves.easeInOut,
                ),
              );

          return SlideTransition(
            position: oldPageAnimation,
            child: SlideTransition(position: newPageAnimation, child: child),
          );
        },
      ),
    );
  }

  // UPDATE NOTE (SLIDE FROM RIGHT)
  void updateNote(Note note) {
    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 400),
        pageBuilder: (context, animation, secondaryAnimation) =>
            AddOrEditNotePage(note: note),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final newPageAnimation =
              Tween<Offset>(
                begin: const Offset(1.0, 0.0),
                end: Offset.zero,
              ).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeInOut),
              );

          final oldPageAnimation =
              Tween<Offset>(
                begin: Offset.zero,
                end: const Offset(-0.3, 0.0),
              ).animate(
                CurvedAnimation(
                  parent: secondaryAnimation,
                  curve: Curves.easeInOut,
                ),
              );

          return SlideTransition(
            position: oldPageAnimation,
            child: SlideTransition(position: newPageAnimation, child: child),
          );
        },
      ),
    );
  }

  // READ NOTE (SLIDE FROM BOTTOM)
  void openReadNotePage(Note note) {
    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 400),
        pageBuilder: (context, animation, secondaryAnimation) =>
            ReadNotePage(note: note),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final newPageAnimation =
              Tween<Offset>(
                begin: const Offset(0.0, 1.0), // muncul dari bawah
                end: Offset.zero,
              ).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeInOut),
              );

          final oldPageAnimation =
              Tween<Offset>(
                begin: Offset.zero,
                end: const Offset(
                  0.0,
                  -0.1,
                ), // sedikit naik saat page baru masuk
              ).animate(
                CurvedAnimation(
                  parent: secondaryAnimation,
                  curve: Curves.easeInOut,
                ),
              );

          return SlideTransition(
            position: oldPageAnimation,
            child: SlideTransition(position: newPageAnimation, child: child),
          );
        },
      ),
    );
  }

  // DELETE NOTE
  void deleteNote(int id) {
    context.read<NoteDatabase>().deleteNote(id);
  }

  @override
  Widget build(BuildContext context) {
    final noteDatabase = context.watch<NoteDatabase>();
    List<Note> currentNotes = noteDatabase.currentNotes;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      // floatingActionButton: Padding(
      //   padding: const EdgeInsets.only(bottom: 32),
        // child: FloatingActionButton(
        //   shape: const CircleBorder(),
        //   onPressed: createNote,
        //   backgroundColor: Theme.of(context).colorScheme.primary,

          // child: Icon(
          //   Icons.add,
          //   color: Theme.of(context).colorScheme.inversePrimary,
          // ),
      //   ),
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,

      drawer: const MyDrawer(),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // HEADING
          Padding(
            padding: const EdgeInsets.only(left: 28.0, top: 10),
            child: Text(
              'Notes',
              style: GoogleFonts.satisfy(
                fontSize: 52,
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
            ),
          ),
          const SizedBox(height: 20),

          // LIST OF NOTES
          Expanded(
            child: ListView.builder(
              itemCount: currentNotes.length,
              itemBuilder: (context, index) {
                final note = currentNotes[index];

                return NoteTile(
                  title: note.title,
                  text: note.text,
                  onTap: () => openReadNotePage(note), // animasi bawah ke atas
                  onEditPressed: () => updateNote(note),
                  onDeletePressed: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text(
                            'Delete Note',
                            style: GoogleFonts.satisfy(
                              fontSize: 30,
                              color: Theme.of(
                                context,
                              ).colorScheme.inversePrimary,
                            ),
                          ),
                          content: const Text(
                            'Are you sure you want to delete this note?',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: Text(
                                'Cancel',
                                style: TextStyle(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.inversePrimary,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, true),
                              child: const Text(
                                'Delete',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    );

                    if (confirm == true) {
                      deleteNote(note.id);
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
