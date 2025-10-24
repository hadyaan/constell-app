import 'package:flutter/material.dart';
import 'package:note_app/components/drawer.dart';
import 'package:note_app/habits/components/my_habit_tile.dart';
import 'package:note_app/habits/components/my_heat_map.dart';
import 'package:note_app/habits/database/habbit_database.dart';
import 'package:note_app/habits/models/habbit.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import '../util/habit_util.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();

    final habitDB = Provider.of<HabbitDatabase>(context, listen: false);
    habitDB.readHabits();
    habitDB.saveFirstLaunchDate();
  }

  // text controller
  final TextEditingController textController = TextEditingController();

  // create new habit
  // void createNewHabit() {
  //   showDialog(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //       content: TextField(
  //         controller: textController,
  //         decoration: const InputDecoration(hintText: "Create a new habit"),
  //       ),
  //       actions: [
  //         // save button
  //         MaterialButton(
  //           onPressed: () {
  //             // get the new habit name
  //             String newHabitName = textController.text;

  //             // save to db
  //             context.read<HabbitDatabase>().addHabit(newHabitName);

  //             // pop box
  //             Navigator.pop(context);

  //             // clear controller
  //             textController.clear();
  //           },
  //           child: const Text('Save'),
  //         ),

  //         // cancel button
  //         MaterialButton(
  //           onPressed: () {
  //             // pop box
  //             Navigator.pop(context);

  //             // clear controller
  //             textController.clear();
  //           },
  //           child: const Text('Cancel'),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // check habit on & off
  void checkHabitOnOff(bool? value, Habit habit) {
    // update habit completion status
    if (value != null) {
      context.read<HabbitDatabase>().updateHabitCompletion(habit.id, value);
    }
  }

  // edit habit box
  void editHabitBox(Habit habit) {
    // set the controller's text to the habit's current name
    textController.text = habit.name;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: TextField(controller: textController),
        actions: [
          // cancel button
          MaterialButton(
            onPressed: () {
              // pop box
              Navigator.pop(context);

              // clear controller
              textController.clear();
            },
            child: Text(
              'Cancel',
              style: TextStyle(
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
            ),
          ),
          // save button
          MaterialButton(
            onPressed: () {
              // get the new habit name
              String newHabitName = textController.text;

              // save to db
              context.read<HabbitDatabase>().updateHabitName(
                habit.id,
                newHabitName,
              );

              // pop box
              Navigator.pop(context);

              // clear controller
              textController.clear();
            },
            child: Text(
              'Save',
              style: TextStyle(
                color: Theme.of(context).colorScheme.inversePrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // cancel button
        ],
      ),
    );
  }

  // delete habit box
  void deleteHabitBox(Habit habit) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Delete Habit',
          style: GoogleFonts.satisfy(
            fontSize: 30,
            color: Theme.of(context).colorScheme.inversePrimary,
          ),
        ),
        content: const Text('Are you sure you want to delete this habit?'),
        actions: [
          // cancel button
          MaterialButton(
            onPressed: () {
              // pop box
              Navigator.pop(context);
            },
            child: Text(
              'Cancel',
              style: TextStyle(
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
            ),
          ),
          // delete button
          MaterialButton(
            onPressed: () {
              // save to db
              context.read<HabbitDatabase>().deleteHabit(habit.id);

              // pop box
              Navigator.pop(context);
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        // title: Text(
        //   "Welcome Back!",
        //   style: GoogleFonts.montserrat(
        //     textStyle: const TextStyle(
        //       fontSize: 20,
        //       fontWeight: FontWeight.bold,
        //     ),
        //   ),
        // ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
        // leading: IconButton(
        //   onPressed: () {
        //     Navigator.pop(context);
        //   },
        //   icon: Icon(Icons.arrow_back_ios_new_rounded),
        // ),
      ),
      // drawer: const MyDrawer(),
      // floatingActionButton: Padding(
      //   padding: const EdgeInsets.only(right: 12, bottom: 12),
      //   child: FloatingActionButton(
      //     onPressed: createNewHabit,
      //     elevation: 0,
      //     shape: const CircleBorder(),
      //     backgroundColor: Theme.of(context).colorScheme.tertiary,
      //     child: const Icon(Icons.add),
      //   ),
      // ),
      drawer: const MyDrawer(),
      body: ListView(
        children: [
          // H E A T M A P
          _buildHeatMap(),
          SizedBox(height: 12),
          // H A B I T L I S T
          _buildHabitList(),
        ],
      ),
    );
  }

  // build heat map
  Widget _buildHeatMap() {
    final habitDB = context.watch<HabbitDatabase>();
    final currentHabits = habitDB.currentHabits;

    return FutureBuilder<DateTime?>(
      future: habitDB.getFirstLaunchDate(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox.shrink(); // menunggu data
        }

        if (snapshot.hasData && snapshot.data != null) {
          return MyHeatMap(
            startDate: snapshot.data!,
            datasets: prepHeatMapDataset(currentHabits),
          );
        } else {
          return const Center(child: Text("No data for heatmap"));
        }
      },
    );
  }

  // build habit list
  Widget _buildHabitList() {
    // habit db
    final HabitDatabase = context.watch<HabbitDatabase>();

    // current habits
    List<Habit> currentHabits = HabitDatabase.currentHabits;

    // return list of habits UI
    return ListView.builder(
      itemCount: currentHabits.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        // get each individual habit
        final habit = currentHabits[index];

        // check if the habit is completed today
        bool isCompletedToday = isHabitCompletedToday(habit.completedDays);

        // return habit tile UI
        return MyHabitTile(
          // key: ValueKey(habit.id),
          text: habit.name,
          isCompleted: isCompletedToday,
          onChanged: (value) => checkHabitOnOff(value, habit),
          editHabit: (context) => editHabitBox(habit),
          deleteHabit: (context) => deleteHabitBox(habit),
        );
      },
    );
  }
}
