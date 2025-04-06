import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/bd/todo_data.dart';
import 'package:todo_app/theme/theme.dart';
import 'package:todo_app/theme/theme_provider.dart';
import 'package:todo_app/widgets/task_tile_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final taskData = Provider.of<TaskData>(context);
    final taskController = TextEditingController();

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        elevation: 0,
        title: const Center(child: Text('Mini ToDo App')),
        actions: [
          IconButton(
              onPressed: () {
                Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
              },
              icon:  Icon(  Provider.of<ThemeProvider>(context).themeData == darkMode ? Icons.sunny : Icons.nightlight))
        ],
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
                    deleteAction: (context) => taskData.deleteTask(task));
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: taskController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Add a task',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(10)),
                    child: IconButton(
                      icon: Icon(
                        Icons.add,
                        color: Theme.of(context).colorScheme.secondary,
                        size: 24,
                      ),
                      onPressed: () {
                        if (taskController.text.isNotEmpty) {
                          taskData.addTask(taskController.text);
                          taskController.clear();
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
