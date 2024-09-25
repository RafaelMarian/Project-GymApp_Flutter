import 'package:flutter/material.dart';

class AchievementsPage extends StatefulWidget {
  const AchievementsPage({super.key});

  @override
  _AchievementsPageState createState() => _AchievementsPageState();
}

class _AchievementsPageState extends State<AchievementsPage> {
  String _sleepDuration = '0'; // Default sleep duration
  double _sleepRating = 0.0;   // Default sleep rating

  @override
  void initState() {
    super.initState();
    _fetchSleepData();
  }

  Future<void> _fetchSleepData() async {
    // Mock fetching the sleep data from Firebase or local storage.
    setState(() {
      _sleepDuration = '7.0'; // Example: 7 hours
      _sleepRating = 87.0;    // Example: sleep rating 87%
    });
  }

  Widget _buildSleepTrackingBox() {
    return Card(
      color: const Color(0xFFF7BB0E), // Yellow background
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Sleep Tracking',
              style: TextStyle(fontSize: 18, color: Colors.black),
            ),
            const SizedBox(height: 10),
            // Sleep progress bar
            LayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.maxWidth * (_parseSleepDuration(_sleepDuration) / 8).clamp(0.0, 1.0);
                return Container(
                  height: 20,
                  color: _getSleepProgressColor(),
                  width: width,
                );
              },
            ),
            const SizedBox(height: 10),
            Text(
              'Sleep Rating: ${_sleepRating.toStringAsFixed(1)}%',
              style: const TextStyle(fontSize: 16, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }

  Color _getSleepProgressColor() {
    final double sleepHours = _parseSleepDuration(_sleepDuration);
    if (sleepHours >= 8) {
      return Colors.green;
    } else if (sleepHours >= 7) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }

  double _parseSleepDuration(String duration) {
    final double? parsed = double.tryParse(duration);
    return parsed ?? 0.0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Achievements'),
        backgroundColor: const Color.fromARGB(255, 40, 39, 41),
      ),
      backgroundColor: const Color.fromARGB(255, 40, 39, 41),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSleepTrackingBox(), // Display the Sleep Tracking box
            // Add other achievement widgets here
          ],
        ),
      ),
    );
  }
}
