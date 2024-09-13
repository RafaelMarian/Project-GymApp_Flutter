import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'custom_circle_for_steps.dart'; // Ensure this file is in your project and adjust the import if necessary

class WaterTrackingPage extends StatefulWidget {
  @override
  _WaterTrackingPageState createState() => _WaterTrackingPageState();
}

class _WaterTrackingPageState extends State<WaterTrackingPage> {
  final TextEditingController _waterController = TextEditingController();
  int _currentIntake = 0;
  int _goal = 2000; // Default goal in ml
  double _progress = 0;
  List<Map<String, dynamic>> _waterHistory = []; // To store history data

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    final now = DateTime.now();
    final startDate = now.subtract(Duration(days: 7));

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('water_data')
          .where('timestamp', isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
          .orderBy('timestamp', descending: true)
          .get();

      List<Map<String, dynamic>> history = [];
      int latestIntake = 0; // Variable to store the most recent intake data

      for (var doc in snapshot.docs) {
        final data = doc.data();
        final intake = data['intake'] as int?;
        final timestamp = (data['timestamp'] as Timestamp).toDate();
        if (intake != null) {
          history.add({
            'date': '${timestamp.year}-${timestamp.month}-${timestamp.day}',
            'intake': intake,
          });
          // Update latestIntake with the most recent entry
          latestIntake = intake;
        }
      }
      setState(() {
        _waterHistory = history;
        _currentIntake = latestIntake; // Set the latest intake as today's intake
        _progress = _currentIntake / _goal;
      });
    } catch (e) {
      print('Error fetching water data: $e');
    }
  }

  void _updateWaterIntake() {
    final intake = int.tryParse(_waterController.text) ?? 0;
    setState(() {
      _currentIntake += intake;
      if (_currentIntake > _goal) {
        _currentIntake = _goal;
      }
      _progress = _currentIntake / _goal;
    });

    FirebaseFirestore.instance.collection('water_data').add({
      'intake': _currentIntake,
      'timestamp': Timestamp.now(),
    });
  }

  Future<void> _clearData() async {
    bool confirmDelete = await _showConfirmationDialog();
    if (confirmDelete) {
      FirebaseFirestore.instance.collection('water_data').get().then((snapshot) {
        for (DocumentSnapshot ds in snapshot.docs) {
          ds.reference.delete();
        }
      });

      setState(() {
        _currentIntake = 0;
        _progress = 0;
        _waterHistory.clear(); // Clear the history as well
      });
    }
  }

  Future<bool> _showConfirmationDialog() async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm Deletion", style: TextStyle(color: Color(0xFFEFE9E1))), // Text color
          content: Text("Are you sure you want to clear all data? This action cannot be undone.", style: TextStyle(color: Color(0xFFEFE9E1))), // Text color
          actions: [
            TextButton(
              child: Text("Cancel", style: TextStyle(color: Color(0xFFD1C7BD))), // Button text color
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: Text("Delete", style: TextStyle(color: Color(0xFFD1C7BD))), // Button text color
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
          'Water Tracking',
          style: TextStyle(color: Color(0xFFEFE9E1)), // Primary text color
        ),
        backgroundColor: const Color(0xFF322D29), // Dark teal
        centerTitle: true, // Center the title
      ),
      backgroundColor: const Color(0xFFD1C7BD), // Lighter beige
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomCircularProgress(
              progress: _progress.clamp(0.0, 1.0),
              size: 150, // Same size as steps counter
              backgroundColor: Color(0xFFD9D9D9), // Light grey
              progressColor: Color(0xFFFFEB3B), // Yellow
            ),
            const SizedBox(height: 20),
            Text(
              '$_currentIntake ml',
              style: const TextStyle(fontSize: 36, color: Color(0xFFEFE9E1)), // Primary text color
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _waterController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFD9D9D9)), // Light grey border
                ),
                filled: true,
                fillColor: Color(0xFFEFE9E1), // Text field background
                labelText: 'Enter Water Intake (ml)',
                labelStyle: TextStyle(color: Color(0xFF322D29)), // Dark teal label text
              ),
            ),
            const SizedBox(height: 20),
            DropdownButton<int>(
              value: _goal,
              items: [1000, 2000, 3000, 4000, 5000].map((int value) {
                return DropdownMenuItem<int>(
                  value: value,
                  child: Text('$value ml', style: TextStyle(color: Color(0xFF322D29))), // Dark teal text color
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _goal = newValue ?? _goal;
                });
              },
              hint: Text('Select your goal', style: TextStyle(color: Color(0xFF322D29))), // Dark teal hint text
            ),
            const SizedBox(height: 20),
            Text(
              'Goal Progress: ${(_progress * 100).toStringAsFixed(1)}%',
              style: const TextStyle(fontSize: 18, color: Color(0xFFEFE9E1)), // Primary text color
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _waterHistory.length,
                itemBuilder: (context, index) {
                  final entry = _waterHistory[index];
                  return Container(
                    margin: EdgeInsets.symmetric(vertical: 5),
                    child: ListTile(
                      title: Text(
                        'Date: ${entry['date']}',
                        style: const TextStyle(color: Color(0xFFEFE9E1)), // Primary text color
                      ),
                      subtitle: Text(
                        'Intake: ${entry['intake']} ml',
                        style: const TextStyle(color: Color(0xFFEFE9E1)), // Primary text color
                      ),
                      tileColor: Color(0xFF322D29), // Dark teal
                      contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: _clearData,
            child: const Icon(Icons.remove, color: Color(0xFFEFE9E1)), // Primary text color
            backgroundColor: const Color.fromARGB(255, 255, 0, 0), // Yellow
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            onPressed: _updateWaterIntake,
            child: const Icon(Icons.add, color: Color(0xFF322D29)), // Dark teal
            backgroundColor: const Color(0xFFFFC400), // Lighter beige
          ),
        ],
      ),
    );
  }
}
