import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/bd/todo_data.dart';
import 'package:todo_app/models/todo_model.dart';
import 'package:todo_app/pages/home_page.dart';
import 'package:todo_app/theme/theme.dart';
import 'package:todo_app/theme/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // init the hive
  await Hive.initFlutter();

  Hive.registerAdapter(TodoModelAdapter());
  // open a box
  final box = await Hive.openBox<TodoModel>('toDoBox');

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (context) => ThemeProvider(),
      ),
      ChangeNotifierProvider(
        create: (context) => TaskData(box),
      ),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
      theme: Provider.of<ThemeProvider>(context).themeData,
      // theme: lightMode,
      // darkTheme: darkMode,

      // ThemeData(
      //   primarySwatch: Colors.blue,
      //   appBarTheme: const AppBarTheme(
      //     backgroundColor: Colors.blue,
      //     foregroundColor: Colors.white,
      //   ),
      // ),
    );
  }
}
