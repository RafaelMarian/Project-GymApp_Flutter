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

  // Track active training plan IDs
  List<String> activeTrainingPlanIds = [];

  @override
  void initState() {
    super.initState();
    // Initialize the active training plan IDs from Firestore
    _loadActiveTrainingPlans();
  }

  // Method to load active training plans from Firestore
  Future<void> _loadActiveTrainingPlans() async {
    final snapshot = await FirebaseFirestore.instance.collection('training-plans').get();
    setState(() {
      activeTrainingPlanIds = snapshot.docs.map((doc) => doc.id).toList();
    });
  }

  // Method to delete an exercise
  Future<void> _deleteExercise(String docId) async {
    try {
      await FirebaseFirestore.instance.collection('user-workout-programs').doc(docId).delete();
      // Refresh the state after deletion
      setState(() {});
    } catch (e) {
      // Handle error, e.g., show a message
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error deleting exercise: $e')));
    }
  }

  // Method to mark an exercise as complete/incomplete
  Future<void> _markAsComplete(String docId, bool isCompleted) async {
    try {
      await FirebaseFirestore.instance.collection('user-workout-programs').doc(docId).update({'completed': !isCompleted});
      // Refresh the state after updating
      setState(() {});
    } catch (e) {
      // Handle error, e.g., show a message
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error updating exercise: $e')));
    }
  }

  // Method to remove a training plan from the displayed list
  void _removeTrainingPlanFromView(String docId) {
    setState(() {
      activeTrainingPlanIds.remove(docId); // Remove the ID from the active list only for view
    });
  }

  // Method to mark a training plan as complete/incomplete
  Future<void> _markTrainingPlanAsComplete(String docId, bool? isCompleted) async {
    try {
      await FirebaseFirestore.instance.collection('training-plans').doc(docId).update({'completed': !(isCompleted ?? false)});
      setState(() {});
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error updating training plan: $e')));
    }
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
                final exercises = snapshot.data!.docs.where((doc) {
                  final exercise = doc.data() as Map<String, dynamic>;
                  return exercise['name'] != null && exercise['name'].isNotEmpty; // Filter out unnamed exercises
                }).toList();
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

                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: trainingPlans.length,
                        itemBuilder: (context, index) {
                          final plan = trainingPlans[index].data() as Map<String, dynamic>;
                          final docId = trainingPlans[index].id;

                          // Skip rendering if the training plan has been marked as removed
                          if (!activeTrainingPlanIds.contains(docId)) {
                            return SizedBox.shrink(); // Render nothing for removed plans
                          }

                          // Extract and format days of the week
                          List<Widget> dayWidgets = [];
                          plan['days'].forEach((key, value) {
                            if (value.isNotEmpty) {
                              dayWidgets.add(Text(
                                '$key: ${value.map((e) => '${e['reps']} reps of ${e['name']} (${e['weight']} kg)').join(', ')}',
                                style: const TextStyle(color: Colors.white),
                              ));
                            }
                          });

                          return Card(
                            color: Colors.grey[850],
                            margin: const EdgeInsets.symmetric(vertical: 8),
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
                                  ...dayWidgets,
                                  const SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      ElevatedButton(
                                        onPressed: () => _removeTrainingPlanFromView(docId),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red,
                                          foregroundColor: Colors.white,
                                        ),
                                        child: const Text('Remove Plan'),
                                      ),
                                      ElevatedButton(
                                        onPressed: () => _markTrainingPlanAsComplete(docId, plan['completed']),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: (plan['completed'] ?? false) ? Colors.grey : Colors.green,
                                          foregroundColor: Colors.white,
                                        ),
                                        child: Text((plan['completed'] ?? false) ? 'Completed' : 'Mark as Done'),
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
