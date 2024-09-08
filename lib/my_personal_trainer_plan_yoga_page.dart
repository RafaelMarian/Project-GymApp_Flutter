import 'package:flutter/material.dart';

class MyPersonalTrainerPlanYogaPage extends StatefulWidget {
  @override
  _MyPersonalTrainerPlanYogaPageState createState() =>
      _MyPersonalTrainerPlanYogaPageState();
}

class _MyPersonalTrainerPlanYogaPageState
    extends State<MyPersonalTrainerPlanYogaPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Personal Trainer Plan (Yoga)'),
        backgroundColor: Colors.grey[800],
      ),
      backgroundColor: Colors.grey[800],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Personalized Yoga Plan',
              style: TextStyle(fontSize: 24, color: Colors.yellow),
            ),
            SizedBox(height: 20),
            Text(
              'Here is your personalized yoga routine to help you with flexibility and mindfulness.',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
            SizedBox(height: 30),
            Expanded(
              child: ListView(
                children: [
                  _buildWorkoutItem('Morning Flow', '10 mins of Sun Salutations'),
                  _buildWorkoutItem('Core Strengthening', '15 mins of Boat Pose'),
                  _buildWorkoutItem('Relaxation', '5 mins of Child\'s Pose'),
                  // Add more yoga exercises
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
          style: TextStyle(color: Colors.yellow, fontSize: 18),
        ),
        subtitle: Text(
          details,
          style: TextStyle(color: Colors.white70, fontSize: 16),
        ),
      ),
    );
  }
}
