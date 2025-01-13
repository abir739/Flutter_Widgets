import 'package:flutter/material.dart';

class AddNoteWidget extends StatefulWidget {
  final ValueChanged<bool> onChangedImportant;
  final ValueChanged<int> onChangedNumber;
  final ValueChanged<String> onChangedTitle;
  final ValueChanged<String> onChangedDescription;

  const AddNoteWidget({
    super.key,
    required this.onChangedImportant,
    required this.onChangedNumber,
    required this.onChangedTitle,
    required this.onChangedDescription,
  });

  @override
  State<AddNoteWidget> createState() => _AddNoteWidgetState();
}

class _AddNoteWidgetState extends State<AddNoteWidget> {
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
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text('Important: '),
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
                Text('Priority: '),
                Expanded(
                  child: Slider(
                    value: (number).toDouble(),
                    min: 0,
                    max: 5,
                    divisions: 5,
                    label: number.toString(),
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
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Description',
                hintText: 'Enter description',
              ),
              validator: (description) =>
                  description != null && description.isEmpty
                      ? 'Type something!'
                      : null,
              onChanged: (value) {
                setState(() => description = value);
                widget.onChangedDescription(value);
              },
              maxLines: 5,
            ),
          ],
        ),
      ),
    );
  }
}
