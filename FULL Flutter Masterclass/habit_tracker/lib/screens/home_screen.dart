import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:habit_tracker/database/habit_db.dart';
import 'package:habit_tracker/models/habit_model.dart';
import 'package:habit_tracker/theme/dark_mode.dart';
import 'package:habit_tracker/theme/theme_provider.dart';
import 'package:habit_tracker/widgets/my_drawer.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController textController = TextEditingController();

  void createNewHabit() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: TextField(
                controller: textController,
                decoration: InputDecoration(
                  hintText: "Start a new Habit !",
                ),
              ),
              actions: [
                MaterialButton(
                  onPressed: () {
                    // get the new habit name
                    String newHabitname = textController.text;
                    if (newHabitname.isNotEmpty) {
                      final newHabit = Habit()
                        ..name = newHabitname
                        ..completedDays = [];

                      // read and save it to database
                      context.read<HabitDatabase>().addHabit(newHabit);

                      // pop box
                      Navigator.pop(context);

                      // clear controller
                      textController.clear();
                    }
                  },
                  child: Text('Add'),
                ),
                MaterialButton(onPressed: () {
                  Navigator.pop(context);
                }, child: Text('Cancel'),)
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Home Screen')),
      ),
      drawer: MyDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: createNewHabit,
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        child: Icon(
          Icons.add,
          color: Theme.of(context).colorScheme.inversePrimary,
        ),
      ),
    );
  }
}
