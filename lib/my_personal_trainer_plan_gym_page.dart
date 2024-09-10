import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyPersonalTrainerPlanPageGym extends StatefulWidget {
  @override
  _AllTrainingPlansPageState createState() => _AllTrainingPlansPageState();
}

class _AllTrainingPlansPageState extends State<MyPersonalTrainerPlanPageGym> {
  List<QueryDocumentSnapshot<Map<String, dynamic>>> plans = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchAllPlans();
  }

  Future<void> _fetchAllPlans() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      final querySnapshot =
          await FirebaseFirestore.instance.collection('training-plans').get();

      if (querySnapshot.docs.isNotEmpty) {
        setState(() {
          plans = querySnapshot.docs;
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'No training plans found in the database.';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error fetching plans: $e';
        isLoading = false;
      });
    }
  }

  Future<void> _deleteTrainingPlan(String planID) async {
    try {
      await FirebaseFirestore.instance.collection('training-plans').doc(planID).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Training plan deleted successfully')),
      );

      // Re-fetch the plans after deletion to update the list
      _fetchAllPlans();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting plan: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Training Plans'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : plans.isNotEmpty
              ? ListView.builder(
                  itemCount: plans.length,
                  itemBuilder: (context, index) {
                    final plan = plans[index];
                    final planID = plan.id;
                    final clientID = plan['clientID'] ?? 'Unknown Client';
                    final difficulty = plan['difficulty'] ?? 'No Difficulty';
                    final workoutType = plan['workoutType'] ?? 'No Workout Type';
                    final gender = plan['gender'] ?? 'No Gender';
                    final days = plan['days'] as Map<String, dynamic>? ?? {};

                    return Card(
                      margin: EdgeInsets.all(8.0),
                      child: ExpansionTile(
                        title: Text(
                          'Client: $clientID',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text('Workout Type: $workoutType, Difficulty: $difficulty'),
                        children: [
                          ...days.keys.map((day) {
                            final exercises = days[day] as List<dynamic>? ?? [];
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    '$day:',
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                ...exercises.map((exercise) {
                                  return ListTile(
                                    title: Text(exercise['name'] ?? 'Unnamed Exercise'),
                                    subtitle: Text(
                                      'Reps: ${exercise['reps']}, Weight: ${exercise['weight']}kg, Rest: ${exercise['restTime']}s',
                                    ),
                                  );
                                }).toList(),
                              ],
                            );
                          }).toList(),
                          ElevatedButton(
                            onPressed: () => _deleteTrainingPlan(planID),
                            child: Text('Delete Plan'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                )
              : Center(
                  child: Text(
                    errorMessage.isNotEmpty
                        ? errorMessage
                        : 'No training plans available.',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
    );
  }
}
