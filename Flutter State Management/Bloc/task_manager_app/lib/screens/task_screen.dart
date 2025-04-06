// UI + BlocBuilder

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager_app/screens/task_bloc.dart';

class TaskScreen extends StatelessWidget {
  const TaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final taskBloc = BlocProvider.of<TaskBloc>(context);
    final TextEditingController taskController = TextEditingController();

    return Scaffold(
        appBar: AppBar(title: const Text("Task Manager")),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: taskController,
                      decoration:
                          const InputDecoration(labelText: "Enter Task"),
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        if (taskController.text.isNotEmpty) {
                          taskBloc.add(AddTask(taskController.text));
                          taskController.clear();
                        }
                      },
                      icon: const Icon(Icons.add))
                ],
              ),
            ),
            BlocBuilder<TaskBloc, TaskState>(builder: (context, state) {
              if (state is TaskListUpdated) {
                return 
                // const Row(
                //   children: [
                //     FilterButton(
                //         label: "All", filter: TaskFilter.all, state: state),
                //   ],
                // );
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "✅ Completed: ${state.completedCount} | ⏳ Pending: ${state.pendingCount}",
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                );
              }
              return const SizedBox.shrink();
            }),
            Expanded(child:
                BlocBuilder<TaskBloc, TaskState>(builder: (context, state) {
              if (state is TaskListUpdated) {
                return ListView.builder(
                  itemCount: state.tasks.length,
                  itemBuilder: (context, index) {
                    final task = state.tasks[index];
                    return ListTile(
                      title: Text(
                        task.title,
                        style: TextStyle(
                            decoration: task.isCompleted
                                ? TextDecoration.lineThrough
                                : TextDecoration.none),
                      ),
                      leading: Checkbox(
                          value: task.isCompleted,
                          onChanged: (_) {
                            taskBloc.add(ToggleTask(index));
                          }),
                      trailing: IconButton(
                          onPressed: () {
                            taskBloc.add(DeleteTAsk(index));
                          },
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          )),
                    );
                  },
                );
              }
              return const Center(
                child: Text("No Tasks available !"),
              );
            }))
          ],
        ));
  }
}

class FilterButton extends StatefulWidget {
  final String labesl;
  final TaskFilter filter;
  final TaskListUpdated state;
  const FilterButton({super.key, required this.labesl, required this.filter, required this.state});

  @override
  State<FilterButton> createState() => _FilterButtonState();
}

class _FilterButtonState extends State<FilterButton> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
