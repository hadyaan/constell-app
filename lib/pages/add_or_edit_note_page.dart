import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:note_app/models/note.dart';
import 'package:note_app/models/note_database.dart';
import 'package:provider/provider.dart';

class AddOrEditNotePage extends StatefulWidget {
  final Note? note; // null = add, not null = edit
  const AddOrEditNotePage({super.key, this.note});

  @override
  State<AddOrEditNotePage> createState() => _AddOrEditNotePageState();
}

class _AddOrEditNotePageState extends State<AddOrEditNotePage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _textController = TextEditingController();

  bool get _hasChanges {
    // Mengecek apakah ada perubahan dari data awal
    if (widget.note == null) {
      return _titleController.text.isNotEmpty ||
          _textController.text.isNotEmpty;
    } else {
      return _titleController.text.trim() !=
              (widget.note!.title ?? "").trim() ||
          _textController.text.trim() != widget.note!.text.trim();
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      _titleController.text = widget.note!.title ?? "";
      _textController.text = widget.note!.text;
    }
  }

  Future<bool> _showDiscardDialog() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Discard changes?',
          style: GoogleFonts.satisfy(
            fontSize: 30,
            color: Theme.of(context).colorScheme.inversePrimary,
          ),
        ),
        content: const Text(
          'You have unsaved changes. Do you want to discard them?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              'Discard',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
    return confirm ?? false;
  }

  void _saveNote() {
    final title = _titleController.text.trim();
    final text = _textController.text.trim();
    if (text.isEmpty && title.isEmpty) return;

    final noteDB = context.read<NoteDatabase>();

    if (widget.note == null) {
      noteDB.addNote(title.isEmpty ? "Untitled" : title, text);
    } else {
      noteDB.updateNote(widget.note!.id, title, text);
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isEditMode = widget.note != null;

    return PopScope(
      canPop: !_hasChanges, // kalau tidak ada perubahan, langsung bisa pop
      onPopInvoked: (didPop) async {
        // kalau sudah pop (true), tidak perlu dialog
        if (didPop) return;

        if (_hasChanges) {
          final shouldDiscard = await _showDiscardDialog();
          if (shouldDiscard && context.mounted) {
            Navigator.pop(context);
          }
        } else {
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            isEditMode ? "Edit Note" : "Add Note",
            style: GoogleFonts.satisfy(
              fontSize: 28,
              color: Theme.of(context).colorScheme.inversePrimary,
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          foregroundColor: Theme.of(context).colorScheme.inversePrimary,
          leading: IconButton(
            onPressed: () async {
              if (_hasChanges) {
                final shouldDiscard = await _showDiscardDialog();
                if (shouldDiscard && context.mounted) Navigator.pop(context);
              } else {
                Navigator.pop(context);
              }
            },
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  hintText: "Title",
                  hintStyle: TextStyle(
                    color: Theme.of(
                      context,
                    ).colorScheme.inversePrimary.withOpacity(0.5),
                  ),
                  border: InputBorder.none,
                ),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
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
                child: TextField(
                  controller: _textController,
                  maxLines: null,
                  decoration: InputDecoration(
                    hintText: "Type your note here...",
                    hintStyle: TextStyle(
                      color: Theme.of(
                        context,
                      ).colorScheme.inversePrimary.withOpacity(0.4),
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: _saveNote,
          label: Text(isEditMode ? "Update" : "Save"),
          icon: const Icon(Icons.check),
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
      ),
    );
  }
}
