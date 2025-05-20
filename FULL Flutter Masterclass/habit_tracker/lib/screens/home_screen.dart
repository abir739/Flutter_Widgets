import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:habit_tracker/database/habit_db.dart';
import 'package:habit_tracker/models/app_settings.dart';
import 'package:habit_tracker/models/habit_model.dart';
import 'package:habit_tracker/screens/heatMap_calendar.dart';
import 'package:habit_tracker/widgets/my_drawer.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController textController = TextEditingController();

  @override
  void initState() {
    super.initState();

    final habitDatabase = Provider.of<HabitDatabase>(context, listen: false);
    habitDatabase.saveFirstLaunchDate();
    habitDatabase.getAllHabits();
  }

  void createNewHabit() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: TextField(
          controller: textController,
          decoration: const InputDecoration(
            hintText: "Start a new Habit!",
          ),
        ),
        actions: [
          MaterialButton(
            onPressed: () {
              String newHabitName = textController.text;
              if (newHabitName.isNotEmpty) {
                final newHabit = Habit()
                  ..name = newHabitName
                  ..completedDays = [];
                context.read<HabitDatabase>().addHabit(newHabit);
                Navigator.pop(context);
                textController.clear();
              }
            },
            child: const Text('Add'),
          ),
          MaterialButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
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
      body: Column(
        children: [
          _heatMapWidget(),
          Expanded(child: _habitListWidget()),
        ],
      ),
    );
  }

// build Heat Map Widget
  Widget _heatMapWidget() {
    return Consumer<HabitDatabase>(
      builder: (context, habitDatabase, child) {
        final habits = habitDatabase.getAllHabits();

        if (habits.isEmpty) {
          return const Center(
            child: Text(
              'No habits yet. Add a new habit!',
              style: TextStyle(fontSize: 16),
            ),
          );
        }


    
        //take the first habit for demonstration
        final habit = habits.first;
            // Get first launch date from settings
    final AppSettings? settings = habitDatabase.settingsBox.get('settings');
    final DateTime startDate = settings?.firstLaunchDate ?? DateTime.now();
    
        // final startDate =
        //     DateTime.now().subtract(Duration(days: 30));

        // Prepare the datasets for the heatmap
        final Map<DateTime, int> datasets = {
          for (var date in habit.completedDays)
            DateTime(date.year, date.month, date.day): 1,
        };

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                'Habit Completion Heatmap',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              HeatMap(
                startDate: startDate,
                endDate: DateTime.now(),
                datasets: datasets,
                colorMode: ColorMode.opacity,
                defaultColor: Theme.of(context).colorScheme.secondary,
                textColor: Colors.white,
                showColorTip: true,
                showText: false,
                scrollable: true,
                size: 30,
                colorsets: {
                  1: Colors.green.shade200,
                  3: Colors.green.shade300,
                  5: Colors.green.shade400,
                  7: Colors.green.shade500,
                  9: Colors.green.shade600,
                  11: Colors.green.shade700,
                  13: Colors.green.shade800,
                },
                onClick: (value) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(value.toString())),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

// Widget _heatMapWidget() {
//   return Consumer<HabitDatabase>(
//     builder: (context, habitDatabase, child) {
//       final habits = habitDatabase.getAllHabits();
//       if (habits.isEmpty) {
//         return const Padding(
//           padding: EdgeInsets.all(16.0),
//           child: Center(child: Text('No habits yet. Add a new habit to see your progress!')),
//         );
//       }

//       // Combine all completedDays from all habits
//       final Map<DateTime, int> combinedDates = {};
//       for (final habit in habits) {
//         for (final date in habit.completedDays) {
//           final normalized = DateTime(date.year, date.month, date.day);
//           combinedDates[normalized] = (combinedDates[normalized] ?? 0) + 1;
//         }
//       }

//       // Find the earliest date for the heatmap start
//       DateTime? earliest;
//       for (final date in combinedDates.keys) {
//         if (earliest == null || date.isBefore(earliest)) {
//           earliest = date;
//         }
//       }
//       final startDate = earliest ?? DateTime.now();

//       return Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'All Habits Completion Heatmap',
//               style: Theme.of(context).textTheme.titleLarge,
//             ),
//             const SizedBox(height: 12),
//             HeatMap(
//               startDate: startDate,
//               endDate: DateTime.now(),
//               datasets: combinedDates,
//               colorMode: ColorMode.opacity,
//               defaultColor: Theme.of(context).colorScheme.secondary,
//               textColor: Colors.white,
//               showColorTip: true,
//               showText: false,
//               scrollable: true,
//               size: 30,
//               colorsets: {
//                 1: Colors.green.shade200,
//                 3: Colors.green.shade300,
//                 5: Colors.green.shade400,
//                 7: Colors.green.shade500,
//                 9: Colors.green.shade600,
//                 11: Colors.green.shade700,
//                 13: Colors.green.shade800,
//               },
//               onClick: (value) {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(content: Text(value.toString())),
//                 );
//               },
//             ),
//           ],
//         ),
//       );
//     },
//   );
// }

  // build Habit List Widget
  Widget _habitListWidget() {
    return Consumer<HabitDatabase>(builder: (context, habitDatabase, child) {
      final habits = habitDatabase.getAllHabits();
      if (habits.isEmpty) {
        return const Center(
          child: Text(
            'No habits yet. Add a new habit!',
            style: TextStyle(fontSize: 16),
          ),
        );
      }
      return ListView.builder(
        itemCount: habits.length,
        itemBuilder: (context, index) {
          final habit = habits[index];
          final today = DateTime.now();
          final normalizedToday = DateTime(today.year, today.month, today.day);
          final isCompletedToday =
              habit.completedDays.contains(normalizedToday);

          return ListTile(
            title: Text(habit.name ?? 'Unnamed Habit'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Checkbox(
                    value: isCompletedToday,
                    onChanged: (value) {
                      habitDatabase.toggleHabitCompletion(index);
                    }),
                IconButton(
                    onPressed: () {
                      final startDate = DateTime.now()
                          .subtract(Duration(days: 30)); // last 30 days
                      final Map<DateTime, int> datasets = {};

                      for (var date in habit.completedDays) {
                        final normalizedDate =
                            DateTime(date.year, date.month, date.day);
                        datasets[normalizedDate] =
                            (datasets[normalizedDate] ?? 0) + 1;
                      }

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HeatmapCalendar(
                            habit: habit,
                            datasets: datasets,
                            startDate: startDate,
                          ),
                        ),
                      );
                    },
                    icon: Icon(Icons.calendar_month))
              ],
            ),
            onLongPress: () {
              showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                        title: const Text('Delete Habit'),
                        content: Text(
                            'Are you sure you want to delete "${habit.name}" ?'),
                        actions: [
                          MaterialButton(
                            onPressed: () {
                              habitDatabase.deleteHabit(index);
                              Navigator.pop(context);
                            },
                            child: const Text('Delete'),
                          ),
                          MaterialButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancel'),
                          )
                        ],
                      ));
            },
            onTap: () {
              textController.text = habit.name ?? '';
              showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                        content: TextField(
                          controller: textController,
                          decoration:
                              InputDecoration(hintText: 'Edit habit name'),
                        ),
                        actions: [
                          MaterialButton(
                            onPressed: () {
                              String newName = textController.text;
                              if (newName.isNotEmpty) {
                                habitDatabase.UpdateHabitName(index, newName);
                                Navigator.pop(context);
                                textController.clear();
                              }
                            },
                            child: const Text('Save'),
                          ),
                          MaterialButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancel'),
                          ),
                        ],
                      ));
            },
          );
        },
      );
    });
  }
}
