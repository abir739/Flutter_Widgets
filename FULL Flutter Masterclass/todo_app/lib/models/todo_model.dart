import 'package:hive/hive.dart';

part 'todo_model.g.dart';
@HiveType(typeId: 0)
class TodoModel extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  bool isDone;

  TodoModel({required this.name, required this.isDone});

  void toggleDone() {
    isDone = !isDone;
  }
}
