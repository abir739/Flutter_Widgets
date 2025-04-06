// BLoC logic
// Handle task-related events and state management.

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager_app/screens/task_model.dart';

abstract class TaskEvent {}

enum TaskFilter { all, completed, pending }

class AddTask extends TaskEvent {
  final String taskTitle;
  AddTask(this.taskTitle);
}

class DeleteTAsk extends TaskEvent {
  final int index;
  DeleteTAsk(this.index);
}

class ToggleTask extends TaskEvent {
  final int index;
  ToggleTask(this.index);
}

class FilterTask extends TaskEvent {
  final TaskFilter filter;
  FilterTask(this.filter);
}

abstract class TaskState {}

class TaskListUpdated extends TaskState {
  final List<TaskModel> tasks;
  final int completedCount;
  final int pendingCount;
  final TaskFilter filter;
  TaskListUpdated(this.tasks, this.filter)
      : completedCount = tasks.where((task) => task.isCompleted).length,
        pendingCount = tasks.where((task) => !(task.isCompleted)).length;

  List<TaskModel> get filteredTasks {
    switch (filter) {
      case TaskFilter.completed:
        return tasks.where((task) => task.isCompleted).toList();
      case TaskFilter.pending:
        return tasks.where((task) => !task.isCompleted).toList();
      case TaskFilter.all:
      default:
        return tasks;
    }
  }
}

// Task Bloc
class TaskBloc extends Bloc<TaskEvent, TaskState> {
  List<TaskModel> taskList = [];
  TaskFilter currentFilter = TaskFilter.all;

  TaskBloc() : super(TaskListUpdated([], TaskFilter.all)) {
    on<AddTask>((event, emit) {
      taskList.add(TaskModel(event.taskTitle, false));
      emit(TaskListUpdated(List.from(taskList), currentFilter));
    });

    on<ToggleTask>(
      (event, emit) {
        taskList[event.index].isCompleted = !taskList[event.index].isCompleted;
        emit(TaskListUpdated(List.from(taskList), currentFilter));
      },
    );

    on<DeleteTAsk>(
      (event, emit) {
        taskList.removeAt(event.index);
        emit(TaskListUpdated(List.from(taskList), currentFilter));
      },
    );
  }
}
