import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CustomGymProgramPage extends StatefulWidget {
  const CustomGymProgramPage({super.key});

  @override
  _CustomGymProgramPageState createState() => _CustomGymProgramPageState();
}

class _CustomGymProgramPageState extends State<CustomGymProgramPage> {
  String? selectedMuscleGroup;
  List<Map<String, dynamic>> defaultExercises = [];
  List<Map<String, dynamic>> userExercises = [];
  Map<String, Map<String, String>> userInput = {}; // Store user input for reps and kg

  void _selectMuscleGroup(String group) {
    setState(() {
      selectedMuscleGroup = group;
      _fetchExercisesForGroup(); // Fetch exercises for the selected group
    });
  }

  Future<void> _fetchExercisesForGroup() async {
    if (selectedMuscleGroup != null) {
      final defaultExercisesSnapshot = await FirebaseFirestore.instance
          .collection('default-gym-exercises')
          .where('muscle_group', isEqualTo: selectedMuscleGroup)
          .get();

      final userExercisesSnapshot = await FirebaseFirestore.instance
          .collection('exercises')
          .where('muscle_group', isEqualTo: selectedMuscleGroup)
          .get();

      setState(() {
        defaultExercises = defaultExercisesSnapshot.docs.map((doc) {
          final data = doc.data();
          data['id'] = doc.id; // Add document ID to the data
          return data;
        }).toList();

        userExercises = userExercisesSnapshot.docs.map((doc) {
          final data = doc.data();
          data['id'] = doc.id; // Add document ID to the data
          return data;
        }).toList();
      });
    }
  }

  Future<void> _updateExercisesInFirestore() async {
    final batch = FirebaseFirestore.instance.batch();

    for (var exercise in [...defaultExercises, ...userExercises]) {
      final exerciseName = exercise['name'] as String;
      final exerciseId = exercise['id'] as String;
      final collection = defaultExercises.contains(exercise) ? 'default-gym-exercises' : 'exercises';

      if (userInput.containsKey(exerciseName)) {
        final docRef = FirebaseFirestore.instance
            .collection(collection)
            .doc(exerciseId); // Reference document by its ID

        final updatedReps = userInput[exerciseName]?['reps'];
        final updatedKg = userInput[exerciseName]?['kg'];

        batch.update(docRef, {
          'reps': int.tryParse(updatedReps ?? '') ?? exercise['reps'] as int,
          'kg': int.tryParse(updatedKg ?? '') ?? exercise['kg'] as int,
        });
      }
    }

    await batch.commit();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Exercises updated successfully')),
    );
  }

  Future<void> _deleteExercise(String exerciseId) async {
    try {
      await FirebaseFirestore.instance.collection('exercises').doc(exerciseId).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Exercise deleted successfully')),
      );
      _fetchExercisesForGroup(); // Refresh the list
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete exercise: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Custom Gym Program'),
        backgroundColor: Color.fromARGB(255, 40, 39, 41),
      ),
      backgroundColor: Color.fromARGB(255, 40, 39, 41),
      body: Column(
        children: [
          DropdownButton<String>(
            value: selectedMuscleGroup,
            hint: const Text('Select Muscle Group', style: TextStyle(color: Colors.white)),
            dropdownColor: Color.fromARGB(255, 0, 0, 0),
            items: <String>['Chest', 'Back', 'Biceps', 'Triceps', 'Legs', 'Abs', 'Shoulders']
                .map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value, style: const TextStyle(color: Colors.white)),
              );
            }).toList(),
            onChanged: (newValue) {
              _selectMuscleGroup(newValue!);
            },
          ),
          Expanded(
            child: ListView.builder(
              itemCount: defaultExercises.length + userExercises.length,
              itemBuilder: (context, index) {
                final isDefault = index < defaultExercises.length;
                final exercise = isDefault ? defaultExercises[index] : userExercises[index - defaultExercises.length];
                final exerciseName = exercise['name'] as String;
                final exerciseDescription = exercise['description'] as String;
                final defaultKg = exercise['kg'] as int;
                final defaultReps = exercise['reps'] as int;
                final userExercise = userInput[exerciseName] ?? {'kg': defaultKg.toString(), 'reps': defaultReps.toString()};

                return Card(
                  color: Color.fromARGB(255, 0, 0, 0),
                  child: ExpansionTile(
                    title: Text(
                      exerciseName,
                      style: const TextStyle(color: Colors.white),
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              exerciseDescription,
                              style: const TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                            ),
                            const SizedBox(height: 10),
                            // Reps input field
                            TextField(
                              decoration: const InputDecoration(
                                labelText: 'Enter Reps',
                                labelStyle: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                                border: OutlineInputBorder(),
                                filled: true,
                                fillColor: Color.fromARGB(255, 0, 0, 0),
                              ),
                              keyboardType: TextInputType.number,
                              controller: TextEditingController(text: userExercise['reps']),
                              onChanged: (value) {
                                setState(() {
                                  userInput[exerciseName] ??= {};
                                  userInput[exerciseName]!['reps'] = value;
                                });
                              },
                            ),
                            const SizedBox(height: 10),
                            // KG input field
                            TextField(
                              decoration: const InputDecoration(
                                labelText: 'Enter Weight (kg)',
                                labelStyle: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                                border: OutlineInputBorder(),
                                filled: true,
                                fillColor: Color.fromARGB(255, 0, 0, 0),
                              ),
                              keyboardType: TextInputType.number,
                              controller: TextEditingController(text: userExercise['kg']),
                              onChanged: (value) {
                                setState(() {
                                  userInput[exerciseName] ??= {};
                                  userInput[exerciseName]!['kg'] = value;
                                });
                              },
                            ),
                            const SizedBox(height: 10),
                            // Delete button for user-added exercises
                            if (!isDefault)
                              ElevatedButton(
                                onPressed: () => _deleteExercise(exercise['id']),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                ),
                                child: const Text('Delete'),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _updateExercisesInFirestore,
        child: const Icon(Icons.check),
      ),
    );
  }
}
