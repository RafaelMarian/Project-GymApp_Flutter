import 'package:flutter/material.dart';

class StepsTrackingPage extends StatefulWidget {
  @override
  _StepsTrackingPageState createState() => _StepsTrackingPageState();
}

class _StepsTrackingPageState extends State<StepsTrackingPage> {
  int _selectedGoal = 5000; // Default goal for steps
  int _currentSteps = 0; // Current steps counted
  double _progress = 0.0;

  void _updateSteps(int steps) {
    setState(() {
      _currentSteps += steps;
      if (_currentSteps > _selectedGoal) {
        _currentSteps = _selectedGoal;
      }
      _progress = _currentSteps / _selectedGoal;
    });
  }

  void _resetSteps() {
    setState(() {
      _currentSteps = 0;
      _progress = 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Steps Counted'),
        backgroundColor: Colors.grey[800],
      ),
      backgroundColor: Colors.grey[800],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Select Your Steps Goal',
              style: TextStyle(fontSize: 18, color: Colors.yellow),
            ),
            const SizedBox(height: 10),
            DropdownButton<int>(
              value: _selectedGoal,
              items: List.generate(20, (index) {
                int goalValue = (index + 1) * 1000;
                return DropdownMenuItem(
                  value: goalValue,
                  child: Text(
                    '$goalValue steps',
                    style: const TextStyle(color: Colors.yellow),
                  ),
                );
              }),
              onChanged: (int? newValue) {
                setState(() {
                  _selectedGoal = newValue!;
                  _progress = _currentSteps / _selectedGoal;
                });
              },
              dropdownColor: Colors.grey[800],
              iconEnabledColor: Colors.yellow,
            ),
            const SizedBox(height: 30),
            Text(
              'Current Steps: $_currentSteps',
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
              onPressed: () => _updateSteps(500),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow,
              ),
              child: const Text('Add 500 steps'),
            ),
            ElevatedButton(
              onPressed: () => _updateSteps(1000),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow,
              ),
              child: const Text('Add 1000 steps'),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: _resetSteps,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: const Text('Reset Steps Count'),
            ),
          ],
        ),
      ),
    );
  }
}
