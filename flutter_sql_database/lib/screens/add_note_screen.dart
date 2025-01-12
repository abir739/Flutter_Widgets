import 'package:flutter/material.dart';
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
      appBar: AppBar(title: const Center(child: Text('Add Note')),),
      body: Form(child: AddNoteWidget()),
    );
  }
}
