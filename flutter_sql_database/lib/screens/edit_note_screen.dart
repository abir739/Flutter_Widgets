import 'package:flutter/material.dart';
import 'package:flutter_sql_database/db/notes_db.dart';
import 'package:flutter_sql_database/model/note_model.dart';
import 'package:flutter_sql_database/widget/edit_note_widget.dart';

class EditNoteScreen extends StatefulWidget {
  final NoteModel note;
  const EditNoteScreen({required this.note, super.key});

  @override
  State<EditNoteScreen> createState() => _EditNoteScreenState();
}

class _EditNoteScreenState extends State<EditNoteScreen> {
  final _formKey = GlobalKey<FormState>();
  late bool isImportant;
  late int number;
  late String title;
  late String description;

  @override
  void initState() {
    super.initState();
    isImportant = widget.note.isImportant;
    number = widget.note.number;
    title = widget.note.title;
    description = widget.note.description;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Edit Note')),
      ),
      body: Form(
        key: _formKey,
        child: EditNoteWidget(
          note: widget.note,
          onChangedImportant: (value) => setState(() => isImportant = value),
          onChangedNumber: (value) => setState(() => number = value),
          onChangedTitle: (value) => setState(() => title = value),
          onChangedDescription: (value) => setState(() => description = value),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: updateNote,
        child: const Icon(Icons.save),
      ),
    );
  }

  void updateNote() async {
    final isValid = _formKey.currentState!.validate();
    if (isValid) {
      final note = widget.note.copyNote(
        isImportant: isImportant,
        number: number,
        title: title,
        description: description,
      );
      await NotesDatabase.instance.updateNote(note);
      Navigator.of(context).pop();
    }
  }
}
