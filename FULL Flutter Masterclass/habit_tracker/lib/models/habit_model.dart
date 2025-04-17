import 'package:hive/hive.dart';

part 'habit_model.g.dart';

@HiveType(typeId: 0)
class Habit extends HiveObject {
  @HiveField(0)
  String? name;

  @HiveField(1)
  List<DateTime> completedDays = [];
}
