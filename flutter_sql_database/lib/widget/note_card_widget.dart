import 'package:flutter/material.dart';
import 'package:flutter_sql_database/model/note_model.dart';
import 'package:intl/intl.dart';

class NoteCardWidget extends StatefulWidget {
  final NoteModel note;
  final int index;
  const NoteCardWidget({super.key, required this.note, required this.index});

  @override
  State<NoteCardWidget> createState() => _NoteCardWidgetState();
}

class _NoteCardWidgetState extends State<NoteCardWidget> {
  @override
  Widget build(BuildContext context) {
    final createdAt = DateFormat.yMMMd().format(widget.note.createdat);
    return Card(
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Text(createdAt),
            Text(widget.note.title)],
        ),
      ),
    );
  }
}
