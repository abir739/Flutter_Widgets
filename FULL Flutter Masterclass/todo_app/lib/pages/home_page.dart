import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/bd/todo_data.dart';
import 'package:todo_app/widgets/task_tile_widget.dart';


class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final taskData = Provider.of<TaskData>(context);
    final taskController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mini ToDo App'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: taskData.taskCount,
              itemBuilder: (context, index) {
                final task = taskData.tasks[index];
                return TaskTileWidget(
                  taskName: task.name,
                   taskIsDone: task.isDone,
                  onChanged: (value) {
                    taskData.updateTask(task);
                  },

                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: taskController,
                    decoration: const InputDecoration(
                      hintText: 'Add a task',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    if (taskController.text.isNotEmpty) {
                      taskData.addTask(taskController.text);
                      taskController.clear();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
