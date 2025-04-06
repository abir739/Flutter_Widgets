import 'package:flutter/material.dart';

class TaskTileWidget extends StatelessWidget {
  final String taskName;
  final bool taskIsDone;
  final Function(bool?) onChanged;

  const TaskTileWidget(
      {super.key,
      required this.taskName,
      required this.taskIsDone,
      required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(taskName),
      trailing: Checkbox(value: taskIsDone, onChanged: onChanged),
    );
  }
}
