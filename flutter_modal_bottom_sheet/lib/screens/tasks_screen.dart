import 'package:flutter/foundation.dart';
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
  final rightEditIcon = Container(
    padding: const EdgeInsets.only(bottom: 10, right: 20),
    alignment: Alignment.centerRight,
    color: Colors.greenAccent,
    child: const Icon(
      Icons.edit,
      color: Colors.white,
    ),
  );

  final leftDeleteIcon = Container(
    padding: const EdgeInsets.only(bottom: 10, left: 20),
    alignment: Alignment.centerLeft,
    color: Colors.red,
    child: const Icon(Icons.delete),
  );

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
            padding: const EdgeInsets.all(20),
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
          Flexible(
            child: GetBuilder<TaskController>(builder: (controller) {
              return ListView.builder(
                itemCount: controller.myTask.length,
                itemBuilder: (context, index) {
                  return Dismissible(
                    background: leftDeleteIcon,
                    secondaryBackground: rightEditIcon,
                    onDismissed: (DismissDirection direction) {
                      print("after dismiss");
                    },
                    confirmDismiss: (DismissDirection direction) async {
                      if (direction == DismissDirection.endToStart) {
                        showModalBottomSheet(
                          backgroundColor: Colors.transparent,
                          barrierColor: Colors.transparent,
                          context: context,
                          builder: (_) {
                            return Container(
                              height: 250,
                              decoration: BoxDecoration(
                                color: const Color(0xFF2e3253).withOpacity(0.4),
                                borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(20),
                                  topLeft: Radius.circular(20),
                                ),
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 20, right: 20),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ElevatedButton(
                                        onPressed: () {},
                                        child: const Text('View')),
                                    ElevatedButton(
                                        onPressed: () {},
                                        child: const Text('Edit')),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                        return false;
                      } else {
                        controller.deleteTask(index);
                        return Future.delayed(
                          const Duration(seconds: 1),
                          () => direction == DismissDirection.startToEnd,
                        );
                      }
                    },
                    key: ObjectKey(index),
                    child: Container(
                      margin: const EdgeInsets.only(
                          left: 20, right: 20, bottom: 10),
                      child: Text(controller.myTask[index]["task_name"]!),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
