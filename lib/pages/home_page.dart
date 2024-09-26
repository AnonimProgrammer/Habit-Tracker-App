import 'package:flutter/material.dart';
import 'package:habit_tracker_app/components/my_drawer.dart';
import 'package:habit_tracker_app/components/my_habit_tile.dart';
import 'package:habit_tracker_app/components/my_heat_map.dart';
import 'package:habit_tracker_app/database/habit_db.dart';
import 'package:habit_tracker_app/models/habit.dart';
import 'package:habit_tracker_app/util/habit_util.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    Provider.of<HabitDatabase>(context, listen: false).readHabits();
    super.initState();
  }

  final TextEditingController textController = TextEditingController();

  // create new habit
  void createNewHabit() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: TextField(
          controller: textController,
          cursorColor: Theme.of(context).colorScheme.inversePrimary,
          decoration: InputDecoration(
            iconColor: Theme.of(context).colorScheme.inversePrimary,
            hintText: 'Add new habit...',
          ),
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // save button
              MaterialButton(
                color: Theme.of(context).colorScheme.secondary,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                onPressed: () {
                  // get the new habit name
                  String newHabitName = textController.text;
                  // save to db
                  context.read<HabitDatabase>().addHabit(newHabitName);
                  // pop box
                  Navigator.pop(context);
                  textController.clear();
                },
                child: const Text('Save'),
              ),
              // cancel button
              MaterialButton(
                color: Theme.of(context).colorScheme.secondary,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                onPressed: () {
                  // pop box
                  Navigator.pop(context);
                  textController.clear();
                },
                child: const Text('Cancel'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // check habit on/off
  void checkHabitOnOff(bool? value, Habit habit) {
    // update complision status
    if (value != null) {
      context.read<HabitDatabase>().updateHabitComplition(habit.id, value);
    }
  }

  // edit habit
  void onEditHabitPressed(Habit habit) {
    // set the controller to the habit's current name
    textController.text = habit.name;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: TextField(
          controller: textController,
          decoration: const InputDecoration(
            hintText: 'Add new habit...',
          ),
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // save button
              MaterialButton(
                color: Theme.of(context).colorScheme.secondary,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                onPressed: () {
                  // get the new habit name
                  String newHabitName = textController.text;
                  // save to db
                  context
                      .read<HabitDatabase>()
                      .updateHabitName(habit.id, newHabitName);
                  // pop box
                  Navigator.pop(context);
                  textController.clear();
                },
                child: const Text('Save'),
              ),
              // cancel button
              MaterialButton(
                color: Theme.of(context).colorScheme.secondary,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                onPressed: () {
                  // pop box
                  Navigator.pop(context);
                  textController.clear();
                },
                child: const Text('Cancel'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // delete habit
  void onDeleteHabitPressed(Habit habit) {
    context.read<HabitDatabase>().deleteHabit(habit.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      drawer: const MyDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: createNewHabit,
        elevation: 1,
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        child: Icon(
          Icons.add,
          color: Theme.of(context).colorScheme.inversePrimary,
        ),
      ),
      body: ListView(
        children: [
          // Heat map
          _buildHeatMap(),

          // Habit list
          _buildHabitList(),
        ],
      ),
    );
  }

  // build heat map
  Widget _buildHeatMap() {
    // habit database
    final habitDatabase = context.watch<HabitDatabase>();
    // current habits
    List<Habit> currentHabits = habitDatabase.currentHabits;

    // return heat map UI
    return FutureBuilder<DateTime?>(
      future: habitDatabase.getFirstLaunchDate(),
      builder: (context, snapshot) {
        // build heat map
        if (snapshot.hasData) {
          return MyHeatMap(
            startDate: snapshot.data!,
            datasets: prepHeatMapDataset(currentHabits),
          );
        }
        // case when no data is returned
        else {
          return Container();
        }
      },
    );
  }

  // build habit list
  Widget _buildHabitList() {
    // habit db
    final habitDatabase = context.watch<HabitDatabase>();
    // current habits
    List<Habit> currentHabits = habitDatabase.currentHabits;

    // return list of habits UI
    return ListView.builder(
      itemCount: currentHabits.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        // get each individual habit
        final habit = currentHabits[index];
        // check if habit is completed today
        bool isCompletedToday = isHabitCompletedToday(habit.completedDays);
        // return habit tile UI
        return HabitTile(
          text: habit.name,
          isCompleted: isCompletedToday,
          onEditHabitPressed: (context) => onEditHabitPressed(habit),
          onDeleteHabitPressed: (context) => onDeleteHabitPressed(habit),
          onChanged: (value) => checkHabitOnOff(value, habit),
        );
      },
    );
  }
}
