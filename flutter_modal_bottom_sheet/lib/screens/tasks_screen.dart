import 'package:flutter/material.dart';
import 'package:flutter_modal_bottom_sheet/screens/app_colors.dart';
import 'package:flutter_modal_bottom_sheet/screens/data_controller.dart';
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
            width: double.maxFinite,
            height: MediaQuery.of(context).size.height / 3.2,
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.only(left: 20, top: 20),
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("lib/assets/images/image.jpg"),
                  fit: BoxFit.cover),
            ),
            child: InkWell(
              onTap: () {
                Get.back();
              },
              child:
                  const Icon(Icons.arrow_back, color: AppColors.secondaryColor),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(top: 10, left: 16, right: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.home,
                      color: AppColors.secondaryColor,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Container(
                      width: 25,
                      height: 25,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.black),
                      child: const Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ],
                ),
                const Row(
                  children: [
                    Icon(
                      Icons.calendar_month_sharp,
                      color: AppColors.secondaryColor,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "2",
                      style: TextStyle(
                          fontSize: 20, color: AppColors.secondaryColor),
                    ),
                  ],
                )
              ],
            ),
          ),
          Flexible(child: GetBuilder<TaskController>(
            builder: (controller) {
              return ListView.builder(
                  itemCount: controller.myTask.length,
                  itemBuilder: (context, index) {
                    return Dismissible(
                        key: ObjectKey(index),
                        child: Container(
                          margin: const EdgeInsets.only(
                              left: 20, right: 20, bottom: 10),
                          child: Text(controller.myTask[index]["task_name"]!),
                        ));
                  });
            },
          ))
        ],
      ),
    );
  }
}
