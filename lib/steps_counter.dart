import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'custom_circle_for_steps.dart';

class StepsCounterPage extends StatefulWidget {
  const StepsCounterPage({super.key});

  @override
  _StepsCounterPageState createState() => _StepsCounterPageState();
}

class _StepsCounterPageState extends State<StepsCounterPage> {
  final TextEditingController _stepsController = TextEditingController();
  int _stepsToday = 0;
  int _goal = 10000; // Default goal
  double _progress = 0;
  double _caloriesBurned = 0;
  List<Map<String, dynamic>> _stepsHistory = []; // To store history data

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    final now = DateTime.now();
    final startDate = now.subtract(const Duration(days: 7));

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('steps_data')
          .where('timestamp', isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
          .orderBy('timestamp', descending: true)
          .get();

      List<Map<String, dynamic>> history = [];
      int latestSteps = 0; // Variable to store the most recent steps data

      for (var doc in snapshot.docs) {
        final data = doc.data();
        final steps = data['steps'] as int?;
        final timestamp = (data['timestamp'] as Timestamp).toDate();
        if (steps != null) {
          history.add({
            'date': '${timestamp.year}-${timestamp.month}-${timestamp.day}',
            'steps': steps,
          });
          // Update latestSteps with the most recent entry
          latestSteps = steps;
        }
      }
      setState(() {
        _stepsHistory = history;
        _stepsToday = latestSteps; // Set the latest steps as today's steps
        _progress = _stepsToday / _goal;
        _caloriesBurned = _stepsToday * 0.04; // Example calculation: 0.04 calories per step
      });
    } catch (e) {
      print('Error fetching steps data: $e');
    }
  }

  void _updateSteps() {
    final steps = int.tryParse(_stepsController.text) ?? 0;
    setState(() {
      _stepsToday = steps;
      _progress = _stepsToday / _goal;
      _caloriesBurned = _stepsToday * 0.04; // Example calculation: 0.04 calories per step
    });

    FirebaseFirestore.instance.collection('steps_data').add({
      'steps': _stepsToday,
      'timestamp': Timestamp.now(),
    });
  }

  Future<void> _clearData() async {
    bool confirmDelete = await _showConfirmationDialog();
    if (confirmDelete) {
      FirebaseFirestore.instance.collection('steps_data').get().then((snapshot) {
        for (DocumentSnapshot ds in snapshot.docs) {
          ds.reference.delete();
        }
      });

      setState(() {
        _stepsToday = 0;
        _progress = 0;
        _caloriesBurned = 0;
        _stepsHistory.clear(); // Clear the history as well
      });
    }
  }

  Future<bool> _showConfirmationDialog() async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm Deletion", style: TextStyle(color: Color.fromARGB(255, 255, 255, 255))),
          content: const Text("Are you sure you want to clear all data? This action cannot be undone.", style: TextStyle(color: Color(0xFF322D29))),
          actions: [
            TextButton(
              child: const Text("Cancel", style: TextStyle(color: Color.fromARGB(255, 255, 255, 255))),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: const Text("Delete", style: TextStyle(color: Colors.red)),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Steps Counter',
          style: TextStyle(color: Color(0xFFF7BB0E)), // Very light cream
        ),
        backgroundColor: const Color.fromARGB(255, 40, 39, 41), // Dark teal
        centerTitle: true, // Center the title
      ),
      body: Container(
        color: const Color.fromARGB(255, 40, 39, 41), // Lighter beige
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomCircularProgress(
                progress: _progress.clamp(0.0, 1.0),
                size: 150, // Smaller size
                backgroundColor: const Color(0xFFD9D9D9), // Light grey
                progressColor: const Color(0xFFFFC400), // Yellow
              ),
              const SizedBox(height: 20),
              Text(
                '$_stepsToday steps',
                style: const TextStyle(fontSize: 36, color: Color.fromARGB(255, 255, 255, 255)), // Dark teal
              ),
              const SizedBox(height: 20),
             Container(
  decoration: BoxDecoration(
    color: const Color.fromARGB(255, 0, 0, 0), // Change this to your desired background color
    borderRadius: BorderRadius.circular(8.0), // Optional: rounded corners for the container
  ),
  child: TextField(
    controller: _stepsController,
    keyboardType: TextInputType.number,
    decoration: const InputDecoration(
      border: OutlineInputBorder(),
      labelText: 'Enter Steps Today',
      labelStyle: TextStyle(
        color: Color.fromARGB(255, 255, 255, 255), // Label color
      ),
      filled: true,
      fillColor: Colors.transparent, // No fill color inside the TextField to see the container background
    ),
  ),
),

              const SizedBox(height: 20),
              DropdownButton<int>(
                value: _goal,
                items: [5000, 10000, 15000, 20000].map((int value) {
                  return DropdownMenuItem<int>(
                    value: value,
                    child: Text('$value steps', style: const TextStyle(color:Color.fromARGB(255, 255, 255, 255))), // Dark teal
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _goal = newValue ?? _goal;
                  });
                },
                hint: const Text('Select your goal', style: TextStyle(color: Color.fromARGB(255, 255, 255, 255))), // Dark teal
              ),
              const SizedBox(height: 20),
              Text(
                'Goal Progress: ${(_progress * 100).toStringAsFixed(1)}%',
                style: const TextStyle(fontSize: 18, color: Color.fromARGB(255, 255, 255, 255)), // Dark teal
              ),
              Text(
                'Calories Burned: ${_caloriesBurned.toStringAsFixed(1)} kcal',
                style: const TextStyle(fontSize: 18, color: Color.fromARGB(255, 255, 255, 255)), // Dark teal
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: _stepsHistory.length,
                  itemBuilder: (context, index) {
                    final entry = _stepsHistory[index];
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      child: ListTile(
                        title: Text(
                          'Date: ${entry['date']}',
                          style: const TextStyle(color: Color.fromARGB(255, 255, 255, 255)), // Very light cream
                        ),
                        subtitle: Text(
                          'Steps: ${entry['steps']}',
                          style: const TextStyle(color: Color.fromARGB(255, 255, 255, 255)), // Very light cream
                        ),
                        tileColor: const Color(0xFF322D29), // Dark teal
                        contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: _clearData,
            backgroundColor: Colors.red,
            child: const Icon(Icons.remove),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            onPressed: _updateSteps,
            backgroundColor: const Color(0xFFFFC400),
            child: const Icon(Icons.add), // Yellow
          ),
        ],
      ),
    );
  }
}
