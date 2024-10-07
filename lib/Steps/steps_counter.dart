import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gym_buddies/Steps/custom_circle_for_steps.dart';
import 'pedometer.dart'; // Import the pedometer service
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StepsCounterPage extends StatefulWidget {
  const StepsCounterPage({super.key});

  @override
  _StepsCounterPageState createState() => _StepsCounterPageState();
}

class _StepsCounterPageState extends State<StepsCounterPage> with WidgetsBindingObserver {
  final TextEditingController _stepsController = TextEditingController();
  int _stepsToday = 0;
  int _goal = 10000; // Default goal
  double _progress = 0;
  double _caloriesBurned = 0;
  List<Map<String, dynamic>> _stepsHistory = []; // To store history data
  PedometerService _pedometerService = PedometerService();
  bool _isCounting = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this); // Add observer
    _fetchData();
    _loadIsCountingState(); // Load the counting state
  }

  // Load counting state from SharedPreferences
  Future<void> _loadIsCountingState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _isCounting = prefs.getBool('isCounting') ?? false; // Default to false
    if (_isCounting) {
      _startCountingSteps(); // Resume counting if it was active
    }
  }

  // Ensure counting is managed properly on app lifecycle events
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _stopCountingSteps();
    } else if (state == AppLifecycleState.resumed) {
      _loadIsCountingState(); // Load state when resumed
    }
  }

  @override
  void dispose() {
    _stopCountingSteps(); // Ensure counting stops when disposed
    WidgetsBinding.instance.removeObserver(this); // Remove observer
    super.dispose();
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

  // Handle starting and stopping pedometer counting
  void _startCountingSteps() async {
    if (!_isCounting) {
      setState(() {
        _isCounting = true;
      });
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool('isCounting', true); // Save state to SharedPreferences

      _pedometerService.startListeningToSteps((newStepCount) {
        setState(() {
          _stepsToday = newStepCount;
          _progress = _stepsToday / _goal;
          _caloriesBurned = _stepsToday * 0.04; // Calories calculation
        });

        // Save steps to Firestore
        FirebaseFirestore.instance.collection('steps_data').add({
          'steps': _stepsToday,
          'timestamp': Timestamp.now(),
        });
      });
    }
  }

  void _stopCountingSteps() async {
    if (_isCounting) {
      setState(() {
        _isCounting = false;
      });
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool('isCounting', false); // Save state to SharedPreferences

      _pedometerService.stopListeningToSteps();
    }
  }

  // Manually add steps from the input block
  void _addStepsFromInput() {
    final steps = int.tryParse(_stepsController.text) ?? 0;
    setState(() {
      _stepsToday += steps;
      _progress = _stepsToday / _goal;
      _caloriesBurned = _stepsToday * 0.04;
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
          title: const Text("Confirm Deletion"),
          content: const Text("Are you sure you want to clear all data? This action cannot be undone."),
          actions: [
            TextButton(
              child: const Text("Cancel"),
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
          style: TextStyle(color: Colors.white), // Light text color
        ),
        backgroundColor: const Color.fromARGB(255, 40, 39, 41), // Dark background
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 40, 39, 41),
              Color.fromARGB(255, 0, 0, 0),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Circular Progress Widget (Unchanged)
              CustomCircularProgress(
                progress: _progress.clamp(0.0, 1.0),
                size: 150,
                backgroundColor: const Color(0xFFD9D9D9), // Light grey
                progressColor: const Color(0xFFFFC400), // Yellow
              ),
              const SizedBox(height: 20),
              Text(
                '$_stepsToday steps',
                style: const TextStyle(fontSize: 36, color: Colors.white),
              ),
              const SizedBox(height: 20),
              // Steps entry (Unchanged)
              Container(
                decoration: BoxDecoration(
                  color: Colors.black, // Black background for input field
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: TextField(
                  controller: _stepsController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Enter Steps Today',
                    labelStyle: TextStyle(
                      color: Colors.white, // Light text color
                    ),
                    filled: true,
                    fillColor: Colors.transparent,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              DropdownButton<int>(
                value: _goal,
                items: [5000, 10000, 15000, 20000].map((int value) {
                  return DropdownMenuItem<int>(
                    value: value,
                    child: Text('$value steps', style: const TextStyle(color: Colors.white)),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _goal = newValue ?? _goal;
                  });
                },
                dropdownColor: const Color(0xFF212121), // Dark dropdown
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildActionButton(
                    title: 'Add Steps',
                    onPressed: _addStepsFromInput,
                  ),
                  _buildActionButton(
                    title: _isCounting ? 'Stop Counting' : 'Start Counting',
                    onPressed: _isCounting ? _stopCountingSteps : _startCountingSteps,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _clearData,
                child: const Text('Clear Data', style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red, // Red button color
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: _stepsHistory.length,
                  itemBuilder: (context, index) {
                    final stepEntry = _stepsHistory[index];
                    return ListTile(
                      title: Text(stepEntry['date'], style: const TextStyle(color: Colors.white)),
                      trailing: Text('${stepEntry['steps']} steps', style: const TextStyle(color: Colors.white)),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Updated button style method
  Widget _buildActionButton({
    required String title,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(title),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 255, 196, 0), // Yellow color
        foregroundColor: Colors.black, // Black text color
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
