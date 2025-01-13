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
  final _cardColors = [
    Colors.blue.shade300,
    Colors.green.shade300,
    Colors.red.shade400,
    Colors.pink.shade300,
    Colors.brown.shade400
  ];

  @override
  Widget build(BuildContext context) {
    final createdAt = DateFormat.yMMMd().format(widget.note.createdat);
    final color = _cardColors[widget.index % _cardColors.length];

    return Card(
      color: color,
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              createdAt,
              style: const TextStyle(fontSize: 13, color: Colors.white),
            ),
            const SizedBox(height: 8),
            Text(
              widget.note.title,
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Priority: ${widget.note.number}',
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
