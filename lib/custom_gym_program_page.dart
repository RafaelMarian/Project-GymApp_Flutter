import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CustomGymProgramPage extends StatefulWidget {
  @override
  _CustomGymProgramPageState createState() => _CustomGymProgramPageState();
}

class _CustomGymProgramPageState extends State<CustomGymProgramPage> {
  String? selectedMuscleGroup;
  List<Map<String, dynamic>> allExercises = [];
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
        allExercises = [
          ...defaultExercisesSnapshot.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            data['id'] = doc.id; // Add document ID to the data
            data['isDefault'] = true; // Mark as default exercise
            return data;
          }).toList(),
          ...userExercisesSnapshot.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            data['id'] = doc.id; // Add document ID to the data
            data['isDefault'] = false; // Mark as user-created exercise
            return data;
          }).toList()
        ];
      });
    }
  }

  Future<void> _updateExercisesInFirestore() async {
    final batch = FirebaseFirestore.instance.batch();

    for (var exercise in allExercises) {
      final exerciseId = exercise['id'] as String;
      final isDefault = exercise['isDefault'] as bool;
      final collection = isDefault ? 'default-gym-exercises' : 'exercises';

      if (userInput.containsKey(exercise['name'])) {
        final docRef = FirebaseFirestore.instance
            .collection(collection)
            .doc(exerciseId);

        final updatedReps = userInput[exercise['name']]?['reps'];
        final updatedKg = userInput[exercise['name']]?['kg'];

        final repsInt = int.tryParse(updatedReps ?? '') ?? exercise['reps'] as int;
        final kgInt = int.tryParse(updatedKg ?? '') ?? exercise['kg'] as int;

        print('Updating ${exercise['name']} in $collection with reps: $repsInt and kg: $kgInt'); // Debug log

        batch.update(docRef, {
          'reps': repsInt,
          'kg': kgInt,
        });
      }
    }

    try {
      await batch.commit();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Exercises updated successfully')),
      );
    } catch (e) {
      print('Error updating exercises: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update exercises')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Custom Gym Program'),
        backgroundColor: Colors.grey[800],
      ),
      backgroundColor: Colors.grey[800],
      body: Column(
        children: [
          DropdownButton<String>(
            value: selectedMuscleGroup,
            hint: Text('Select Muscle Group', style: TextStyle(color: Colors.white)),
            dropdownColor: Colors.grey[800],
            items: <String>['Chest', 'Back', 'Biceps', 'Triceps', 'Legs', 'Abs', 'Shoulders']
                .map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value, style: TextStyle(color: Colors.white)),
              );
            }).toList(),
            onChanged: (newValue) {
              _selectMuscleGroup(newValue!);
            },
          ),
          Expanded(
            child: ListView.builder(
              itemCount: allExercises.length,
              itemBuilder: (context, index) {
                final exercise = allExercises[index];
                final exerciseName = exercise['name'] as String;
                final exerciseDescription = exercise['description'] as String;
                final defaultKg = exercise['kg'] as int;
                final defaultReps = exercise['reps'] as int;
                final userExercise = userInput[exerciseName] ?? {'kg': defaultKg.toString(), 'reps': defaultReps.toString()};

                return Card(
                  color: Colors.grey[850],
                  child: ExpansionTile(
                    title: Text(
                      exerciseName,
                      style: TextStyle(color: Colors.white),
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              exerciseDescription,
                              style: TextStyle(color: Colors.grey),
                            ),
                            SizedBox(height: 10),
                            // Reps input field
                            TextField(
                              decoration: InputDecoration(
                                labelText: 'Enter Reps',
                                labelStyle: TextStyle(color: Colors.black),
                                border: OutlineInputBorder(),
                                filled: true,
                                fillColor: Colors.white,
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
                            SizedBox(height: 10),
                            // KG input field
                            TextField(
                              decoration: InputDecoration(
                                labelText: 'Enter Weight (kg)',
                                labelStyle: TextStyle(color: Colors.black),
                                border: OutlineInputBorder(),
                                filled: true,
                                fillColor: Colors.white,
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
        child: Icon(Icons.check),
      ),
    );
  }
}
