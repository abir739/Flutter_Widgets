import 'package:flutter/material.dart';
import 'package:habit_tracker/database/habit_db.dart';
import 'package:habit_tracker/models/app_settings.dart';
import 'package:habit_tracker/models/habit_model.dart';
import 'package:habit_tracker/screens/home_screen.dart';
import 'package:habit_tracker/theme/theme_provider.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  // initialize the Hive
  WidgetsFlutterBinding.ensureInitialized();
  final dir = await getApplicationDocumentsDirectory();

  Hive.init(dir.path);

  // Hive register Adapters: Habit + AppSettings
  Hive.registerAdapter(HabitAdapter());
  Hive.registerAdapter(AppSettingsAdapter());

  // Open a Hive Box
  await Hive.openBox<Habit>('habits');
  await Hive.openBox<AppSettings>('app_settings');

  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(
        create: (context) => ThemeProvider(),
      ),
      ChangeNotifierProvider(create: (context) => HabitDatabase())
    ], child: const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: Provider.of<ThemeProvider>(context).themeData,
      home: const HomeScreen(),
    );
  }
}
