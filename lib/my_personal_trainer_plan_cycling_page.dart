import 'package:flutter/material.dart';

class MyPersonalTrainerPlanCyclingPage extends StatefulWidget {
  const MyPersonalTrainerPlanCyclingPage({super.key});

  @override
  _MyPersonalTrainerPlanCyclingPageState createState() =>
      _MyPersonalTrainerPlanCyclingPageState();
}

class _MyPersonalTrainerPlanCyclingPageState
    extends State<MyPersonalTrainerPlanCyclingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Personal Trainer Plan (Cycling)'),
        backgroundColor: Colors.grey[800],
      ),
      backgroundColor: Colors.grey[800],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Personalized Cycling Plan',
              style: TextStyle(fontSize: 24, color: Colors.yellow),
            ),
            const SizedBox(height: 20),
            const Text(
              'Here is your personalized cycling plan tailored to improve your stamina and endurance.',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
            const SizedBox(height: 30),
            Expanded(
              child: ListView(
                children: [
                  _buildWorkoutItem('Endurance Ride', '30 mins at moderate pace'),
                  _buildWorkoutItem('Hill Climb', '20 mins of hill intervals'),
                  _buildWorkoutItem('Speed Training', '15 mins of sprints'),
                  // Add more cycling exercises
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWorkoutItem(String workoutName, String details) {
    return Card(
      color: Colors.grey[700],
      child: ListTile(
        title: Text(
          workoutName,
          style: const TextStyle(color: Colors.yellow, fontSize: 18),
        ),
        subtitle: Text(
          details,
          style: const TextStyle(color: Colors.white70, fontSize: 16),
        ),
      ),
    );
  }
}
