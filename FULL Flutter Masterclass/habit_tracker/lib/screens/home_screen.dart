import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:habit_tracker/database/habit_db.dart';
import 'package:habit_tracker/models/app_settings.dart';
import 'package:habit_tracker/models/habit_model.dart';
import 'package:habit_tracker/screens/heat_map_calendar.dart';
import 'package:habit_tracker/theme/dark_mode.dart';
import 'package:habit_tracker/theme/theme_provider.dart';
import 'package:habit_tracker/widgets/my_drawer.dart';
import 'package:provider/provider.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:animations/animations.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final TextEditingController textController = TextEditingController();
  late TabController _tabController;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 2, vsync: this);

    final habitDatabase = Provider.of<HabitDatabase>(context, listen: false);
    habitDatabase.saveFirstLaunchDate();
    habitDatabase.getAllHabits();
  }

  @override
  void dispose() {
    textController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void createNewHabit() {
    showModal(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Create New Habit',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        content: TextField(
          controller: textController,
          decoration: InputDecoration(
            hintText: "What habit would you like to track?",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.primary,
                width: 2,
              ),
            ),
          ),
          autofocus: true,
          maxLength: 50,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              String newHabitName = textController.text.trim();
              if (newHabitName.isNotEmpty) {
                final newHabit = Habit()
                  ..name = newHabitName
                  ..completedDays = [];
                context.read<HabitDatabase>().addHabit(newHabit);
                Navigator.pop(context);
                textController.clear();

                // Show confirmation
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('New habit created!'),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    backgroundColor:
                        Theme.of(context).colorScheme.primaryContainer,
                    duration: Duration(seconds: 2),
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
            ),
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode =
        Provider.of<ThemeProvider>(context).themeData == darkMode;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          'Habit Tracker',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
        actions: [
          IconButton(
            icon: Icon(isDarkMode ? Icons.dark_mode : Icons.light_mode),
            onPressed: () => Provider.of<ThemeProvider>(context, listen: false)
                .toggleTheme(),
            tooltip:
                isDarkMode ? 'Switch to Light Mode' : 'Switch to Dark Mode',
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Theme.of(context).colorScheme.primary,
          indicatorWeight: 3,
          tabs: [
            Tab(text: 'HABITS', icon: Icon(Icons.list_alt)),
            Tab(text: 'PROGRESS', icon: Icon(Icons.calendar_month)),
          ],
        ),
      ),
      drawer: MyDrawer(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: createNewHabit,
        elevation: 2,
        backgroundColor: Theme.of(context).colorScheme.primary,
        icon: Icon(
          Icons.add,
          color: Theme.of(context).colorScheme.onPrimary,
        ),
        label: Text(
          'New Habit',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: TabBarView(
        controller: _tabController,
        children: [
          _habitListWidget(),
          _progressWidget(),
        ],
      ),
    );
  }

  // Progress tab with heatmap and stats
  Widget _progressWidget() {
    return Consumer<HabitDatabase>(
      builder: (context, habitDatabase, child) {
        final habits = habitDatabase.getAllHabits();

        if (habits.isEmpty) {
          return _emptyStateWidget(
            'No habits to track yet',
            'Add your first habit to see your progress!',
            Icons.trending_up,
          );
        }

        // Calculate overall completion rate
        final today = DateTime.now();
        final lastWeek = today.subtract(Duration(days: 7));
        int totalPossible = habits.length * 7; // 7 days x number of habits
        int totalCompleted = 0;

        for (var habit in habits) {
          for (var i = 0; i < 7; i++) {
            final checkDate = today.subtract(Duration(days: i));
            final normalizedDate =
                DateTime(checkDate.year, checkDate.month, checkDate.day);
            if (habit.completedDays.contains(normalizedDate)) {
              totalCompleted++;
            }
          }
        }

        double completionRate =
            totalPossible > 0 ? totalCompleted / totalPossible : 0;

        // Get first launch date from settings
        final AppSettings? settings = habitDatabase.settingsBox.get('settings');
        final DateTime startDate = settings?.firstLaunchDate ?? DateTime.now();

        // Take the first habit for demonstration
        final habit = habits.first;

        // Prepare the datasets for the heatmap
        final Map<DateTime, int> datasets = {
          for (var date in habit.completedDays)
            DateTime(date.year, date.month, date.day): 1,
        };

        return SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Progress summary card
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Last 7 Days',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            CircularPercentIndicator(
                              radius: 60.0,
                              lineWidth: 12.0,
                              percent: completionRate,
                              center: Text(
                                "${(completionRate * 100).toStringAsFixed(0)}%",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.0,
                                ),
                              ),
                              progressColor:
                                  Theme.of(context).colorScheme.primary,
                              backgroundColor:
                                  Theme.of(context).colorScheme.surfaceVariant,
                              circularStrokeCap: CircularStrokeCap.round,
                              animation: true,
                              animationDuration: 1200,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _statRow(Icons.check_circle_outline,
                                    '$totalCompleted Completed', Colors.green),
                                SizedBox(height: 8),
                                _statRow(
                                    Icons.trending_up,
                                    '${habits.length} Active Habits',
                                    Theme.of(context).colorScheme.primary),
                                SizedBox(height: 8),
                                _statRow(
                                    Icons.calendar_today,
                                    '${DateTime.now().difference(startDate).inDays} Days Tracked',
                                    Colors.orange),
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 24),

                Text(
                  'Habit Activity',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: 16),

                // Heatmap container
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: HeatMap(
                      startDate: startDate,
                      endDate: DateTime.now(),
                      datasets: datasets,
                      colorMode: ColorMode.opacity,
                      defaultColor: Theme.of(context).colorScheme.secondary,
                      textColor: Theme.of(context).colorScheme.onSurface,
                      showColorTip: true,
                      showText: true,
                      scrollable: true,
                      size: 32,
                      colorsets: {
                        1: Colors.green.shade100,
                        2: Colors.green.shade300,
                        3: Colors.green.shade500,
                        4: Colors.green.shade700,
                        5: Colors.green.shade900,
                        // 1: Colors.green.shade200,
                        // 3: Colors.green.shade300,
                        // 5: Colors.green.shade400,
                        // 7: Colors.green.shade500,
                        // 9: Colors.green.shade600,
                        // 11: Colors.green.shade700,
                        // 13: Colors.green.shade800,
                      },
                      onClick: (value) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              "${value.day}/${value.month}/${value.year}",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            behavior: SnackBarBehavior.floating,
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            duration: Duration(seconds: 1),
                          ),
                        );
                      },
                    ),
                  ),
                ),

                SizedBox(height: 24),

                // Individual habit stats
                Text(
                  'Habit Details',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: 8),

                ...habits.map((habit) {
                  int completedCount = habit.completedDays.length;
                  // Count completions in last 7 days
                  int recentCompletions = 0;
                  for (var i = 0; i < 7; i++) {
                    final checkDate = today.subtract(Duration(days: i));
                    final normalizedDate = DateTime(
                        checkDate.year, checkDate.month, checkDate.day);
                    if (habit.completedDays.contains(normalizedDate)) {
                      recentCompletions++;
                    }
                  }

                  return Card(
                    margin: EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      title: Text(
                        habit.name ?? 'Unnamed Habit',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text('${recentCompletions}/7 days this week'),
                      trailing: CircularPercentIndicator(
                        radius: 24.0,
                        lineWidth: 5.0,
                        percent: recentCompletions / 7,
                        center: Text(
                          "${recentCompletions}",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12.0,
                          ),
                        ),
                        progressColor: recentCompletions >= 5
                            ? Colors.green
                            : recentCompletions >= 3
                                ? Colors.orange
                                : Colors.red,
                        backgroundColor:
                            Theme.of(context).colorScheme.surfaceVariant,
                        circularStrokeCap: CircularStrokeCap.round,
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HeatmapCalendar(
                              habit: habit,
                              datasets: {
                                for (var date in habit.completedDays)
                                  DateTime(date.year, date.month, date.day): 1,
                              },
                              startDate:
                                  DateTime.now().subtract(Duration(days: 60)),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _statRow(IconData icon, String text, Color color) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }

  // Habits tab with list of habits
  Widget _habitListWidget() {
    return Consumer<HabitDatabase>(
      builder: (context, habitDatabase, child) {
        final habits = habitDatabase.getAllHabits();

        if (habits.isEmpty) {
          return _emptyStateWidget(
            'No habits yet',
            'Tap the + button to add your first habit!',
            Icons.add_task,
          );
        }

        return ListView.builder(
          padding: EdgeInsets.only(bottom: 80), // Space for FAB
          itemCount: habits.length,
          itemBuilder: (context, index) {
            final habit = habits[index];
            final today = DateTime.now();
            final normalizedToday =
                DateTime(today.year, today.month, today.day);
            final isCompletedToday =
                habit.completedDays.contains(normalizedToday);

            // Calculate streak
            int currentStreak = 0;
            DateTime checkDate = normalizedToday;

            // If completed today, include today in streak
            if (isCompletedToday) {
              currentStreak = 1;
              checkDate = checkDate.subtract(Duration(days: 1));
            }

            // Check previous consecutive days
            while (true) {
              final normalizedCheck =
                  DateTime(checkDate.year, checkDate.month, checkDate.day);
              if (habit.completedDays.contains(normalizedCheck)) {
                currentStreak++;
                checkDate = checkDate.subtract(Duration(days: 1));
              } else {
                break;
              }
            }

            return Slidable(
              endActionPane: ActionPane(
                motion: const ScrollMotion(),
                children: [
                  SlidableAction(
                    onPressed: (context) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HeatmapCalendar(
                            habit: habit,
                            datasets: {
                              for (var date in habit.completedDays)
                                DateTime(date.year, date.month, date.day): 1,
                            },
                            startDate:
                                DateTime.now().subtract(Duration(days: 60)),
                          ),
                        ),
                      );
                    },
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    icon: Icons.calendar_month,
                    label: 'Stats',
                  ),
                  SlidableAction(
                    onPressed: (context) {
                      textController.text = habit.name ?? '';
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Edit Habit'),
                          content: TextField(
                            controller: textController,
                            decoration: InputDecoration(
                              hintText: 'Edit habit name',
                              border: OutlineInputBorder(),
                            ),
                            autofocus: true,
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Cancel'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                String newName = textController.text.trim();
                                if (newName.isNotEmpty) {
                                  habitDatabase.UpdateHabitName(index, newName);
                                  Navigator.pop(context);
                                  textController.clear();
                                }
                              },
                              child: const Text('Save'),
                            ),
                          ],
                        ),
                      );
                    },
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    icon: Icons.edit,
                    label: 'Edit',
                  ),
                  SlidableAction(
                    onPressed: (context) {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Delete Habit'),
                          content: Text(
                            'Are you sure you want to delete "${habit.name}" ?',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                habitDatabase.deleteHabit(index);
                                Navigator.pop(context);
                              },
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.red,
                              ),
                              child: const Text('Delete'),
                            ),
                          ],
                        ),
                      );
                    },
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    icon: Icons.delete,
                    label: 'Delete',
                  ),
                ],
              ),
              child: Card(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: isCompletedToday
                      ? BorderSide(color: Colors.green, width: 2)
                      : BorderSide.none,
                ),
                child: ListTile(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  title: Text(
                    habit.name ?? 'Unnamed Habit',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      decoration: isCompletedToday
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),
                  subtitle: currentStreak > 0
                      ? Text(
                          '🔥 ${currentStreak} day streak',
                          style: TextStyle(
                            color: Colors.orange,
                            fontWeight: FontWeight.w500,
                          ),
                        )
                      : null,
                  leading: CircleAvatar(
                    backgroundColor: isCompletedToday
                        ? Colors.green
                        : Theme.of(context).colorScheme.surfaceVariant,
                    child: IconButton(
                      icon: Icon(
                        isCompletedToday ? Icons.check : Icons.circle_outlined,
                        color: isCompletedToday
                            ? Colors.white
                            : Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      onPressed: () {
                        habitDatabase.toggleHabitCompletion(index);
                      },
                    ),
                  ),
                  trailing: Text(
                    'Total: ${habit.completedDays.length}',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  // Empty state widget
  Widget _emptyStateWidget(String title, String subtitle, IconData icon) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 80,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
            ),
            SizedBox(height: 24),
            Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 12),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
