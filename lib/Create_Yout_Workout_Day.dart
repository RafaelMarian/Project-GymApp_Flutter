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

  @override
  void initState() {
    super.initState();
  }

  // Method to delete an exercise
  Future<void> _deleteExercise(String docId) async {
    try {
      await FirebaseFirestore.instance.collection('user-workout-programs').doc(docId).delete();
      setState(() {});
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error deleting exercise: $e')));
    }
  }

  // Method to mark an exercise as complete/incomplete
  Future<void> _markAsComplete(String docId, bool isCompleted) async {
    try {
      await FirebaseFirestore.instance.collection('user-workout-programs').doc(docId).update({'completed': !isCompleted});
      setState(() {});
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error updating exercise: $e')));
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
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('user-workout-programs')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final exercises = snapshot.data!.docs.where((doc) {
                  final exercise = doc.data() as Map<String, dynamic>;
                  return exercise['name'] != null && exercise['name'].isNotEmpty;
                }).toList();

                totalExercises = exercises.length;
                completedExercises = exercises.where((doc) => doc['completed'] == true).length;

                // Group exercises by day
                Map<String, List<Map<String, dynamic>>> groupedExercises = {};
                for (var doc in exercises) {
                  final exercise = doc.data() as Map<String, dynamic>;
                  final day = exercise['day'] ?? 'Unknown';

                  if (!groupedExercises.containsKey(day)) {
                    groupedExercises[day] = [];
                  }
                  groupedExercises[day]!.add(exercise);
                }

                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: LinearProgressIndicator(
                        value: totalExercises == 0 ? 0 : completedExercises / totalExercises,
                        backgroundColor: Colors.grey[800],
                        valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
                      ),
                    ),
                    groupedExercises.isEmpty
                        ? const Center(
                            child: Text(
                              'No exercises added',
                              style: TextStyle(color: Colors.white),
                            ),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: groupedExercises.keys.length,
                            itemBuilder: (context, index) {
                              final day = groupedExercises.keys.elementAt(index);
                              final exercisesForDay = groupedExercises[day]!;

                              return Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      day,
                                      style: const TextStyle(
                                        color: Color(0xFFF7BB0E),
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Column(
                                      children: exercisesForDay.map((exercise) {
                                        final docId = exercise['id'];
                                        final bool isCompleted = exercise['completed'] ?? false;

                                        return Card(
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
                                                Text(
                                                  exercise['name'] ?? 'Unnamed Exercise',
                                                  style: const TextStyle(
                                                    color: Color(0xFFF7BB0E),
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                const SizedBox(height: 10),
                                                Text(
                                                  'Reps: ${exercise['reps']?.toString() ?? '0'}',
                                                  style: const TextStyle(color: Colors.white),
                                                ),
                                                const SizedBox(height: 10),
                                                Text(
                                                  'Weight: ${exercise['weight']?.toString() ?? '0'} kg',
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
                                        );
                                      }).toList(),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
