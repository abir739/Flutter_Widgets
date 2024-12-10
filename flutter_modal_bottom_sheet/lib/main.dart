import 'package:flutter/material.dart';
import 'package:flutter_modal_bottom_sheet/screens/data_controller.dart';
import 'package:flutter_modal_bottom_sheet/screens/tasks_screen.dart';
import 'package:get/get.dart';

void main() {
  Get.put(TaskController()); // Initialize the TaskController
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Task Manager',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MyTasks(),
    );
  }
}
