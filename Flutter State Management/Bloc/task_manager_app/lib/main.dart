import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager_app/screens/task_bloc.dart';
import 'package:task_manager_app/screens/task_screen.dart';

void main() {
  runApp(BlocProvider(
    create: (context) => TaskBloc(),
    child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
    debugShowCheckedModeBanner: false,
      home: BlocProvider(
        create: (context) => TaskBloc(),
        child: const TaskScreen()),
    );
  }
}

