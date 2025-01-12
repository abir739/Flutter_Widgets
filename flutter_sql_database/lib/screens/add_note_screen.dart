import 'package:flutter/material.dart';
import 'package:flutter_sql_database/db/notes_db.dart';
import 'package:flutter_sql_database/model/note_model.dart';
import 'package:flutter_sql_database/widget/add_note_widget.dart';

class AddNoteScreen extends StatefulWidget {
  final NoteModel? note;
  const AddNoteScreen({required this.note, super.key});

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

    isImportant = widget.note?.isImportant ?? false;
    number = widget.note?.number ?? 0;
    title = widget.note?.title ?? '';
    description = widget.note?.description ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Add Note')),
      ),
      body: Column(
        children: [
          Form(key: _formKey, child: const AddNoteWidget()),
          ElevatedButton(onPressed: createNote, child: const Text('Creat Note'))
        ],
      ),
    );
  }

  void createNote() async {
    final isValid = _formKey.currentState!.validate();
    final note = NoteModel(
        isImportant: true,
        number: number,
        title: title,
        description: description,
        createdat: DateTime.now());

    if (isValid) {
      await NotesDatabase.instance.createNote(note);
    }
    setState(() {
      NotesDatabase.instance.readAllNotes();
      Navigator.of(context).pop();
    });
  }
}
