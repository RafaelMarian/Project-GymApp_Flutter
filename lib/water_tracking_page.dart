import 'package:flutter/material.dart';

class WaterTrackingPage extends StatefulWidget {
  @override
  _WaterTrackingPageState createState() => _WaterTrackingPageState();
}

class _WaterTrackingPageState extends State<WaterTrackingPage> {
  int _selectedGoal = 2000; // Default goal in ml
  int _currentIntake = 0; // Current water intake
  double _progress = 0.0;

  void _updateWaterIntake(int amount) {
    setState(() {
      _currentIntake += amount;
      if (_currentIntake > _selectedGoal) {
        _currentIntake = _selectedGoal;
      }
      _progress = _currentIntake / _selectedGoal;
    });
  }

  void _resetWaterIntake() {
    setState(() {
      _currentIntake = 0;
      _progress = 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Water Tracking'),
        backgroundColor: Colors.grey[800],
      ),
      backgroundColor: Colors.grey[800],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Select Your Water Goal (ml)',
              style: TextStyle(fontSize: 18, color: Colors.yellow),
            ),
            const SizedBox(height: 10),
            DropdownButton<int>(
              value: _selectedGoal,
              items: List.generate(10, (index) {
                int goalValue = (index + 1) * 500;
                return DropdownMenuItem(
                  value: goalValue,
                  child: Text(
                    '$goalValue ml',
                    style: const TextStyle(color: Colors.yellow),
                  ),
                );
              }),
              onChanged: (int? newValue) {
                setState(() {
                  _selectedGoal = newValue!;
                  _progress = _currentIntake / _selectedGoal;
                });
              },
              dropdownColor: Colors.grey[800],
              iconEnabledColor: Colors.yellow,
            ),
            const SizedBox(height: 30),
            Text(
              'Current Intake: $_currentIntake ml',
              style: const TextStyle(fontSize: 18, color: Colors.yellow),
            ),
            const SizedBox(height: 20),
            LinearProgressIndicator(
              value: _progress,
              backgroundColor: Colors.grey,
              color: Colors.yellow,
              minHeight: 20,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _updateWaterIntake(250),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow,
              ),
              child: const Text('Add 250 ml'),
            ),
            ElevatedButton(
              onPressed: () => _updateWaterIntake(500),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow,
              ),
              child: const Text('Add 500 ml'),
            ),
            const Spacer(), // Pushes the reset button down
            ElevatedButton(
              onPressed: _resetWaterIntake,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: const Text('Reset Intake'),
            ),
          ],
        ),
      ),
    );
  }
}
