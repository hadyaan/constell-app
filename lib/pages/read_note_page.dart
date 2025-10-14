import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:note_app/models/note.dart';

class ReadNotePage extends StatelessWidget {
  final Note note;
  const ReadNotePage({super.key, required this.note});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // kosongkan appbar
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.keyboard_arrow_down_rounded, size: 36),
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title di dalam body
            Text(
              note.title.isEmpty ? "Untitled" : note.title,
              style: GoogleFonts.satisfy(
                fontSize: 32,
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
            ),
            Divider(
              color: Theme.of(
                context,
              ).colorScheme.inversePrimary.withOpacity(0.4),
              thickness: 1,
              height: 24,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  note.text,
                  style: const TextStyle(fontSize: 16, height: 1.4),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
