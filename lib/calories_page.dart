import 'package:flutter/material.dart';

class CaloriesPage extends StatefulWidget {
  const CaloriesPage({super.key});

  @override
  _CaloriesPageState createState() => _CaloriesPageState();
}

class _CaloriesPageState extends State<CaloriesPage> {
  // Placeholder for calorie tracking data
  int _caloriesBurned = 0;

  @override
  void initState() {
    super.initState();
    _fetchCalorieData();
  }

  Future<void> _fetchCalorieData() async {
    // Your logic for fetching and calculating calorie data goes here
    // For demonstration, we're just setting a static value
    setState(() {
      _caloriesBurned = 2500; // Example static value
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calories Burned'),
        backgroundColor: const Color.fromARGB(255, 40, 39, 41),
      ),
      backgroundColor: const Color.fromARGB(255, 40, 39, 41),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Total Calories Burned:',
              style: const TextStyle(color: Colors.white, fontSize: 24),
            ),
            const SizedBox(height: 10),
            Text(
              '$_caloriesBurned kcal',
              style: const TextStyle(color: Colors.white, fontSize: 48, fontWeight: FontWeight.bold),
            ),
            // Add more widgets or functionality for calorie tracking here
          ],
        ),
      ),
    );
  }
}
