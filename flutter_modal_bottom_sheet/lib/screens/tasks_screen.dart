import 'package:flutter/material.dart';
import 'package:flutter_modal_bottom_sheet/screens/app_colors.dart';
import 'package:get/get.dart';

class MyTasks extends StatefulWidget {
  const MyTasks({super.key});

  @override
  State<MyTasks> createState() => _MyTasksState();
}

class _MyTasksState extends State<MyTasks> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            child: InkWell(
              onTap: () {
                Get.back();
              },
              child:  Icon(Icons.arrow_back, color: AppColors.secondaryColor),
            ),
          )
        ],
      ),
    );
  }
}
