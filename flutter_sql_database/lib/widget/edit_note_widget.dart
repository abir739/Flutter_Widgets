import 'package:flutter/material.dart';
import 'package:flutter_sql_database/model/note_model.dart';

class EditNoteWidget extends StatefulWidget {
  final NoteModel note;
  final ValueChanged<bool> onChangedImportant;
  final ValueChanged<int> onChangedNumber;
  final ValueChanged<String> onChangedTitle;
  final ValueChanged<String> onChangedDescription;

  const EditNoteWidget({
    super.key,
    required this.note,
    required this.onChangedImportant,
    required this.onChangedNumber,
    required this.onChangedTitle,
    required this.onChangedDescription,
  });

  @override
  State<EditNoteWidget> createState() => _EditNoteWidgetState();
}

class _EditNoteWidgetState extends State<EditNoteWidget> {
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
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          children: [
            Row(
              children: [
                Switch(
                  value: isImportant,
                  onChanged: (value) {
                    setState(() => isImportant = value);
                    widget.onChangedImportant(value);
                  },
                ),
                Expanded(
                  child: Slider(
                    value: number.toDouble(),
                    onChanged: (value) {
                      setState(() => number = value.toInt());
                      widget.onChangedNumber(value.toInt());
                    },
                  ),
                ),
              ],
            ),
            TextFormField(
              initialValue: title,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Title',
                hintStyle: TextStyle(color: Colors.grey),
              ),
              validator: (title) => title != null && title.isEmpty
                  ? 'The title can\'t be empty'
                  : null,
              onChanged: (value) {
                setState(() => title = value);
                widget.onChangedTitle(value);
              },
            ),
            TextFormField(
              initialValue: description,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Description...',
                hintStyle: TextStyle(color: Colors.grey),
              ),
              validator: (description) =>
                  description != null && description.isEmpty
                      ? 'Type something!'
                      : null,
              onChanged: (value) {
                setState(() => description = value);
                widget.onChangedDescription(value);
              },
            ),
          ],
        ),
      ),
    );
  }
}
