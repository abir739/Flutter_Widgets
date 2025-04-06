import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class TaskTileWidget extends StatelessWidget {
  final String taskName;
  final bool taskIsDone;
  final Function(bool?) onChanged;
  final Function(BuildContext) deleteAction;

  const TaskTileWidget({
    super.key,
    required this.taskName,
    required this.taskIsDone,
    required this.onChanged,
    required this.deleteAction,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 25, left: 25, right: 25),
      child: Slidable(
        endActionPane: ActionPane(
          motion: const StretchMotion(),
          children: [
            SlidableAction(
              onPressed: (context) => deleteAction(context),
              icon: Icons.delete,
              backgroundColor: Colors.red,
              borderRadius: BorderRadius.circular(14),
            ),
          ],
        ),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(14),
          ),
          child: ListTile(
            title: Text(
              taskName,
              style: TextStyle(
                fontSize: 16,
                decoration: taskIsDone
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
              ),
            ),
            trailing: Checkbox(
              value: taskIsDone,
              onChanged: onChanged,
              activeColor: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
