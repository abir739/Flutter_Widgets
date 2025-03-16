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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text('Important: '),
                Switch(
                  value: isImportant,
                  onChanged: (value) {
                    setState(() => isImportant = value);
                    widget.onChangedImportant(value);
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Text('Priority: '),
                Expanded(
                  child: Slider(
                    value: (number).toDouble(),
                    min: 0,
                    max: 5,
                    divisions: 5,
                    onChanged: (value) {
                      setState(() => number = value.toInt());
                      widget.onChangedNumber(value.toInt());
                    },
                  ),
                ),
                Text(number.toString()),
              ],
            ),
            const SizedBox(height: 20),
            TextFormField(
              initialValue: title,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Title',
                hintText: 'Enter title',
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
            const SizedBox(height: 20),
            TextFormField(
              initialValue: description,
              maxLines: 7,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Description',
                hintText: 'Enter description',
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
