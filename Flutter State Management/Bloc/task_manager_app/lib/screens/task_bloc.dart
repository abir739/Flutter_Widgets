// BLoC logic
// Handle task-related events and state management.

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager_app/screens/task_model.dart';

abstract class TaskEvent {}

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

abstract class TaskState {}

class TaskListUpdated extends TaskState {
  final List<TaskModel> tasks;
  final int completedCount;
  final int pendingCount;
  TaskListUpdated(this.tasks)
      : completedCount = tasks.where((task) => task.isCompleted).length,
        pendingCount = tasks.where((task) => !(task.isCompleted)).length;
}

// Task Bloc
class TaskBloc extends Bloc<TaskEvent, TaskState> {
  List<TaskModel> taskList = [];

  TaskBloc() : super(TaskListUpdated([])) {
    on<AddTask>((event, emit) {
      taskList.add(TaskModel(event.taskTitle, false));
      emit(TaskListUpdated(List.from(taskList)));
    });

    on<ToggleTask>(
      (event, emit) {
        taskList[event.index].isCompleted = !taskList[event.index].isCompleted;
        emit(TaskListUpdated(List.from(taskList)));
      },
    );

    on<DeleteTAsk>(
      (event, emit) {
        taskList.removeAt(event.index);
        emit(TaskListUpdated(List.from(taskList)));
      },
    );
  }
}
