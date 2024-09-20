import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PlannedGymProgramsPage extends StatefulWidget {
  const PlannedGymProgramsPage({super.key});

  @override
  _PlannedGymProgramsPageState createState() => _PlannedGymProgramsPageState();
}

class _PlannedGymProgramsPageState extends State<PlannedGymProgramsPage> {
  String? selectedDifficulty;
  String? selectedWorkoutType;
  String? selectedGender;
  Map<String, dynamic>? workoutRoutine;

  // Fetch workout plan based on selected criteria
  Future<void> _fetchWorkoutPlan() async {
    if (selectedDifficulty != null && selectedWorkoutType != null && selectedGender != null) {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('planned_gym_programs')
          .where('difficulty', isEqualTo: selectedDifficulty)
          .where('workout_type', isEqualTo: selectedWorkoutType)
          .where('gender', isEqualTo: selectedGender)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        setState(() {
          workoutRoutine = querySnapshot.docs.first.data();
        });
      } else {
        setState(() {
          workoutRoutine = null;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Planned Gym Programs'),
        backgroundColor: const Color.fromARGB(255, 40, 39, 41),
      ),
      backgroundColor: const Color.fromARGB(255, 40, 39, 41),
      body: Column(
        children: [
          // Dropdown for difficulty
          DropdownButton<String>(
            value: selectedDifficulty,
            hint: const Text('Select Difficulty', style: TextStyle(color: Colors.white)),
            dropdownColor: const Color.fromARGB(255, 0, 0, 0),
            items: <String>['Beginner', 'Intermediate', 'Advanced'].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value, style: const TextStyle(color: Colors.white)),
              );
            }).toList(),
            onChanged: (newValue) {
              setState(() {
                selectedDifficulty = newValue;
              });
            },
          ),
          // Dropdown for workout type
          DropdownButton<String>(
            value: selectedWorkoutType,
            hint: const Text('Select Workout Type', style: TextStyle(color: Colors.white)),
            dropdownColor: const Color.fromARGB(255, 0, 0, 0),
            items: <String>[
              'Full Body', 
              'One Muscle Group Per Day', 
              'Two Muscle Groups Per Day', 
              'Push Pull Legs', 
              'Upper Lower'
            ].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value, style: const TextStyle(color: Colors.white)),
              );
            }).toList(),
            onChanged: (newValue) {
              setState(() {
                selectedWorkoutType = newValue;
              });
            },
          ),
          // Dropdown for gender
          DropdownButton<String>(
            value: selectedGender,
            hint: const Text('Select Gender', style: TextStyle(color: Colors.white)),
            dropdownColor: const Color.fromARGB(255, 0, 0, 0),
            items: <String>['Male', 'Female'].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value, style: const TextStyle(color: Colors.white)),
              );
            }).toList(),
            onChanged: (newValue) {
              setState(() {
                selectedGender = newValue;
              });
            },
          ),
          ElevatedButton(
  onPressed: _fetchWorkoutPlan,
  style: ElevatedButton.styleFrom(
    backgroundColor: const Color(0xFFF7BB0E), // Background color
    foregroundColor: const Color.fromARGB(255, 0, 0, 0), // Text color
  ),
  child: const Text('Fetch Workout Plan'),
),
          Expanded(
            child: workoutRoutine != null
                ? ListView.builder(
                    itemCount: workoutRoutine!['days'].length, // Loop over the days
                    itemBuilder: (context, index) {
                      // Get the day name (like 'Monday', 'Tuesday', etc.)
                      String dayName = workoutRoutine!['days'].keys.elementAt(index);

                      // Get the day's details (muscle groups and exercises)
                      final day = workoutRoutine!['days'][dayName];

                      // Access the exercises as a List
                      final List exercises = day['exercises'] as List;

                      return Card(
                        color: Colors.grey[850],
                        child: ListTile(
                          title: Text(
                            '$dayName: ${day['muscle_groups'].join(', ')}',
                            style: const TextStyle(color: Color(0xFFF7BB0E)),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: exercises.map<Widget>((exercise) {
                              return Text(
                                '${exercise['name']} - ${exercise['reps']} reps',
                                style: const TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                              );
                            }).toList(),
                          ),
                        ),
                      );
                    },
                  )
                : const Center(
                    child: Text(
                      'No workout plan selected.',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
