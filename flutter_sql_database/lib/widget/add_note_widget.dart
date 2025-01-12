import 'package:flutter/material.dart';

class AddNoteWidget extends StatefulWidget {
  final bool? isImportant;
  final int? number;
  final String? title;
  final String? description;
  const AddNoteWidget(
      {super.key, this.isImportant, this.number, this.title, this.description});

  @override
  State<AddNoteWidget> createState() => _AddNoteWidgetState();
}

class _AddNoteWidgetState extends State<AddNoteWidget> {
  late final ValueChanged<bool> onChangedImportant;

  late final ValueChanged<int> onChangedNumber;

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
                    value: widget.isImportant ?? false,
                    onChanged: onChangedImportant),
                Expanded(
                    child: Slider(
                        value: (widget.number ?? 0).toDouble(),
                        onChanged: (number) => onChangedNumber(number.toInt())))
              ],
            ),
            TextFormField(
              initialValue: widget.title,
              decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Title',
                  hintStyle: TextStyle(color: Colors.grey)),
              validator: (title) => title != null && title.isEmpty
                  ? 'The title can\'t be emty'
                  : null,
            ),
            TextFormField(
              initialValue: widget.description,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Description...',
                hintStyle: TextStyle(color: Colors.grey),
              ),
              validator: (description) =>
                  description != null && description.isEmpty
                      ? 'Type Something!'
                      : null,
            )
          ],
        ),
      ),
    );
  }
}
