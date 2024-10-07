import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CreateYourWorkoutDay extends StatefulWidget {
  const CreateYourWorkoutDay({super.key});

  @override
  _CreateYourWorkoutDayState createState() => _CreateYourWorkoutDayState();
}

class _CreateYourWorkoutDayState extends State<CreateYourWorkoutDay> {
  int totalExercises = 0;
  int completedExercises = 0;

  // Method to delete an exercise
  void _deleteExercise(String docId) {
    FirebaseFirestore.instance.collection('user-workout-programs').doc(docId).delete();
  }

  // Method to mark an exercise as complete/incomplete
  void _markAsComplete(String docId, bool isCompleted) {
    FirebaseFirestore.instance.collection('user-workout-programs').doc(docId).update({'completed': !isCompleted});
  }

  // Method to delete a training plan
  void _deleteTrainingPlan(String docId) {
    FirebaseFirestore.instance.collection('training-plans').doc(docId).delete();
  }

  // Method to mark a training plan as complete/incomplete
  void _markTrainingPlanAsComplete(String docId, bool isCompleted) {
    FirebaseFirestore.instance.collection('training-plans').doc(docId).update({'completed': !isCompleted});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Your Workout Day'),
        backgroundColor: const Color.fromARGB(255, 40, 39, 41),
      ),
      backgroundColor: const Color.fromARGB(255, 40, 39, 41),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Fetch and display exercises
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('user-workout-programs') // Fetching workout programs
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                // List of exercises from Firestore
                final exercises = snapshot.data!.docs;
                totalExercises = exercises.length;
                completedExercises = exercises.where((doc) => doc['completed'] == true).length;

                return Column(
                  children: [
                    // Progress bar to show the completion rate of exercises
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: LinearProgressIndicator(
                        value: totalExercises == 0 ? 0 : completedExercises / totalExercises,
                        backgroundColor: Colors.grey[800],
                        valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
                      ),
                    ),
                    // Exercise List
                    exercises.isEmpty
                        ? const Center(
                            child: Text(
                              'No exercises added',
                              style: TextStyle(color: Colors.white),
                            ),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: exercises.length,
                            itemBuilder: (context, index) {
                              // Extract data from each document
                              final exercise = exercises[index].data() as Map<String, dynamic>;
                              final docId = exercises[index].id;
                              final bool isCompleted = exercise['completed'] ?? false;

                              return Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Card(
                                  color: Colors.grey[850],
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        // Display exercise image
                                        if (exercise['image'] != null)
                                          Center(
                                            child: SizedBox(
                                              height: 200,
                                              child: Image.asset(
                                                'assets/${exercise['name']?.toLowerCase()?.replaceAll(' ', '_') ?? 'default_image'}.png',
                                                fit: BoxFit.cover,
                                                errorBuilder: (context, error, stackTrace) {
                                                  return const Center(
                                                    child: Text('No Image', style: TextStyle(color: Colors.white)),
                                                  );
                                                },
                                              ),
                                            ),
                                          ),
                                        // Display exercise name
                                        Text(
                                          exercise['name'] ?? 'Unnamed Exercise',
                                          style: const TextStyle(
                                            color: Color(0xFFF7BB0E),
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        // Display number of reps
                                        Text(
                                          'Reps: ${exercise['reps']?.toString() ?? '0'}',
                                          style: const TextStyle(color: Colors.white),
                                        ),
                                        const SizedBox(height: 10),
                                        // Display weight (kg)
                                        Text(
                                          'Weight: ${exercise['weight']?.toString() ?? '0'} kg',
                                          style: const TextStyle(color: Colors.white),
                                        ),
                                        const SizedBox(height: 10),
                                        // Buttons to delete and mark exercise as complete
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            ElevatedButton(
                                              onPressed: () => _deleteExercise(docId),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.red,
                                                foregroundColor: Colors.white,
                                              ),
                                              child: const Text('Delete'),
                                            ),
                                            ElevatedButton(
                                              onPressed: () => _markAsComplete(docId, isCompleted),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: isCompleted ? Colors.grey : Colors.green,
                                                foregroundColor: Colors.white,
                                              ),
                                              child: Text(isCompleted ? 'Completed' : 'Mark as Done'),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                  ],
                );
              },
            ),
            // Training Plan Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Training Plans:',
                    style: TextStyle(
                      color: Color(0xFFF7BB0E),
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Fetch and display the training plan
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('training-plans') // Adjust this to your training plans collection
                        .snapshots(),
                    builder: (context, trainingPlanSnapshot) {
                      if (!trainingPlanSnapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      final trainingPlans = trainingPlanSnapshot.data!.docs;

                      if (trainingPlans.isEmpty) {
                        return const Text(
                          'No training plans available.',
                          style: TextStyle(color: Colors.white),
                        );
                      }

                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: trainingPlans.length,
                        itemBuilder: (context, index) {
                          final plan = trainingPlans[index].data() as Map<String, dynamic>;
                          final docId = trainingPlans[index].id;

                          // Extract and format days of the week
                          List<String> days = [];
                          plan['days'].forEach((key, value) {
                            if (value is List) {
                              days.add('$key: ${value.map((e) => e['name'] ?? 'Unnamed Exercise').join(', ')}');
                            }
                          });

                          return Card(
                            color: Colors.grey[850],
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Client: ${plan['clientName'] ?? 'Unknown'}',
                                    style: const TextStyle(
                                      color: Color(0xFFF7BB0E),
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    'Workout Type: ${plan['workoutType'] ?? 'N/A'}',
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    'Difficulty: ${plan['difficulty'] ?? 'N/A'}',
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    'Days:\n${days.join('\n')}', // Display the formatted days
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  const SizedBox(height: 10),
                                  // Buttons to delete and mark training plan as complete
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      ElevatedButton(
                                        onPressed: () => _deleteTrainingPlan(docId),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red,
                                          foregroundColor: Colors.white,
                                        ),
                                        child: const Text('Delete'),
                                      ),
                                      ElevatedButton(
                                        onPressed: () => _markTrainingPlanAsComplete(docId, false), // Assuming false as default completion
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.green,
                                          foregroundColor: Colors.white,
                                        ),
                                        child: const Text('Mark as Done'),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
