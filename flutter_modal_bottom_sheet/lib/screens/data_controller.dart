import 'package:get/get.dart';

class TaskController extends GetxController {
  var myTask = <Map<String, String>>[].obs;

  @override
  void onInit() {
    super.onInit();
    //Initialise the data
    myTask.addAll([
      {"task_name": "Try harder"},
      {"task_name": "Try smarter"},
    ]);
  }

  void addTask(String taskName) {
    myTask.add({"task_name": taskName});
  }

  void deleteTask(int index) {
    myTask.removeAt(index);
  }
}
