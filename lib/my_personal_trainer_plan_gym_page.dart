import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyPersonalTrainerPlanPageGym extends StatefulWidget {
  @override
  _MyPersonalTrainerPlanPageState createState() => _MyPersonalTrainerPlanPageState();
}

class _MyPersonalTrainerPlanPageState extends State<MyPersonalTrainerPlanPageGym> {
  Map<String, dynamic>? trainingPlan;

  @override
  void initState() {
    super.initState();
    _fetchTrainingPlan();
  }

  Future<void> _fetchTrainingPlan() async {
    final userId = 'current_user_id'; // Replace with the actual logged-in user ID

    final querySnapshot = await FirebaseFirestore.instance
        .collection('training-plans')
        .where('clientID', isEqualTo: userId)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      setState(() {
        trainingPlan = querySnapshot.docs.first.data() as Map<String, dynamic>;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Personal Trainer Plan'),
      ),
      body: trainingPlan != null
          ? ListView.builder(
              itemCount: trainingPlan!['days'].length,
              itemBuilder: (context, index) {
                final dayName = trainingPlan!['days'].keys.elementAt(index);
                final day = trainingPlan!['days'][dayName] as Map<String, dynamic>;
                final List exercises = day['exercises'] as List;

                return Card(
                  color: Colors.grey[850],
                  child: ListTile(
                    title: Text(
                      '$dayName: ${day['muscle_groups'].join(', ')}',
                      style: TextStyle(color: Colors.white),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: exercises.map<Widget>((exercise) {
                        return Text(
                          '${exercise['name']} - ${exercise['reps']} reps',
                          style: TextStyle(color: Colors.grey),
                        );
                      }).toList(),
                    ),
                  ),
                );
              },
            )
          : Center(
              child: Text(
                'No training plan assigned.',
                style: TextStyle(color: Colors.white),
              ),
            ),
    );
  }
}
