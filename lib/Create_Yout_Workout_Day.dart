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

  void _deleteExercise(String docId) {
    FirebaseFirestore.instance.collection('user-workout-programs').doc(docId).delete();
  }

  void _markAsComplete(String docId, bool isCompleted) {
    FirebaseFirestore.instance.collection('user-workout-programs').doc(docId).update({'completed': !isCompleted});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Your Workout Day'),
        backgroundColor: const Color.fromARGB(255, 40, 39, 41),
      ),
      backgroundColor: const Color.fromARGB(255, 40, 39, 41),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('user-workout-programs')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final exercises = snapshot.data!.docs;
          totalExercises = exercises.length;
          completedExercises = exercises.where((doc) {
            try {
              return doc['completed'] == true; // Safely check for completed
            } catch (e) {
              print("Error checking completed status: $e");
              return false; // Default to false if error occurs
            }
          }).length;

          return Column(
            children: [
              // Progress bar at the top
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: LinearProgressIndicator(
                  value: totalExercises == 0 ? 0 : completedExercises / totalExercises,
                  backgroundColor: Colors.grey[800],
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
                ),
              ),
              Expanded(
                child: exercises.isEmpty
                    ? const Center(
                        child: Text(
                          'No exercises added',
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    : ListView.builder(
                        itemCount: exercises.length,
                        itemBuilder: (context, index) {
                          final exercise = exercises[index].data() as Map<String, dynamic>;
                          final docId = exercises[index].id;
                          final bool isCompleted = exercise['completed'] ?? false; // Use ?? to provide a default value

                          return Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Card(
                              color: Colors.grey[850],
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (exercise['image'] != null)
                                      Center(
                                        child: SizedBox(
                                          height: 200,
                                          child: Image.asset(
                                            'assets/${exercise['name'].toLowerCase().replaceAll(' ', '_')}.png',
                                            fit: BoxFit.cover,
                                            errorBuilder: (context, error, stackTrace) {
                                              return const Center(
                                                child: Text('No Image', style: TextStyle(color: Colors.white)),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    Text(
                                      exercise['name'],
                                      style: const TextStyle(
                                        color: Color(0xFFF7BB0E),
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      'Reps: ${exercise['reps']}',
                                      style: const TextStyle(color: Colors.white),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      'Weight: ${exercise['kg']} kg',
                                      style: const TextStyle(color: Colors.white),
                                    ),
                                    const SizedBox(height: 10),
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
                                        // Green box to mark as complete
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
              ),
            ],
          );
        },
      ),
    );
  }
}
