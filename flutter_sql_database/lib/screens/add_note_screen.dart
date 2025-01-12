import 'package:flutter/material.dart';
import 'package:flutter_sql_database/db/notes_db.dart';
import 'package:flutter_sql_database/model/note_model.dart';
import 'package:flutter_sql_database/widget/add_note_widget.dart';

class AddNoteScreen extends StatefulWidget {
  const AddNoteScreen({super.key});

  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  final _formKey = GlobalKey<FormState>();
  late bool isImportant;
  late int number;
  late String title;
  late String description;

  @override
  void initState() {
    super.initState();
    isImportant = false;
    number = 0;
    title = '';
    description = '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Add Note')),
      ),
      body: Form(
        key: _formKey,
        child: AddNoteWidget(
          onChangedImportant: (value) => setState(() => isImportant = value),
          onChangedNumber: (value) => setState(() => number = value),
          onChangedTitle: (value) => setState(() => title = value),
          onChangedDescription: (value) => setState(() => description = value),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: createNote,
        child: const Icon(Icons.save),
      ),
    );
  }

  void createNote() async {
    final isValid = _formKey.currentState!.validate();
    if (isValid) {
      final note = NoteModel(
        isImportant: isImportant,
        number: number,
        title: title,
        description: description,
        createdat: DateTime.now(),
      );
      await NotesDatabase.instance.createNote(note);
      Navigator.of(context).pop();
    }
  }
}
