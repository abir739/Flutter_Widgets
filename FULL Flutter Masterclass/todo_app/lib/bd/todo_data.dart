import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:todo_app/models/todo_model.dart';

class TaskData extends ChangeNotifier {
  // reference the hive box
  // final _box = Hive.openBox('toDoBox)
  final Box<TodoModel> _box;

  TaskData(this._box);

  List<TodoModel> get tasks => _box.values.toList();

  int get taskCount => _box.length;

  void addTask(String taskName) {
    _box.add(TodoModel(name: taskName, isDone: false));
    notifyListeners();
  }

  void deleteTask(TodoModel task) {
    task.delete();
    notifyListeners();
  }

  void updateTask(TodoModel task) {
    task.toggleDone();
    task.save();
    notifyListeners();
  }
}
