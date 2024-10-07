import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'flutter_month_picher.dart'; // Ensure this import is correct

class WorkoutProgressPage extends StatefulWidget {
  const WorkoutProgressPage({super.key});

  @override
  _WorkoutProgressPageState createState() => _WorkoutProgressPageState();
}

class _WorkoutProgressPageState extends State<WorkoutProgressPage> {
  List<bool> _checkedDays = List.generate(31, (index) => false); // Assume 31 days
  DateTime _selectedDate = DateTime.now(); // Default to current date
  int _points = 0; // Points for checked days in the current month
  int _cases = 0; // Cases for the current month
  int _totalPoints = 0; // Total points across all months
  int _totalCases = 0; // Total cases across all months

  @override
  void initState() {
    super.initState();
    _fetchDataForMonth(_selectedDate); // Fetch data for the default month
    _fetchTotalPoints(); // Fetch total points when the page loads
    _fetchTotalCases(); // Fetch total cases when the page loads
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Workout Progress'),
        backgroundColor: const Color.fromARGB(255, 40, 39, 41),
      ),
      backgroundColor: const Color.fromARGB(255, 40, 39, 41),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Total Points: $_totalPoints', // Display the total points at the top
              style: const TextStyle(fontSize: 18, color: Colors.white),
            ),
            const SizedBox(height: 10),
            Text(
              'Total Cases: $_totalCases', // Display the total cases at the top
              style: const TextStyle(fontSize: 18, color: Colors.white),
            ),
            const SizedBox(height: 10),
            Text(
              'Selected Month: ${DateFormat('MMMM yyyy').format(_selectedDate)}',
              style: const TextStyle(fontSize: 18, color: Colors.white),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                ),
                itemCount: _checkedDays.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _checkedDays[index] = !_checkedDays[index]; // Toggle checked state
                        _calculatePointsAndCases(); // Recalculate points and cases
                        _saveCheckedDays(); // Save state to Firebase
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: _checkedDays[index] ? Colors.green : Colors.grey[800],
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Center(
                        child: Text(
                          '${index + 1}',
                          style: const TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Text(
                      'Points: $_points',
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      'Cases: $_cases',
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      'Checked: ${_checkedDays.where((day) => day).length}', // Show checked count for the current month
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF7BB0E),
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return MonthPickerDialog(
                      selectedDate: _selectedDate,
                      onChanged: (date) {
                        setState(() {
                          _selectedDate = date;
                        });
                      },
                    );
                  },
                ).then((_) {
                  _fetchDataForMonth(_selectedDate); // Fetch data after dialog is dismissed
                });
              },
              child: const Text('Select Month'),
            ),
          ],
        ),
      ),
    );
  }

  void _calculatePointsAndCases() {
    // Count how many boxes are checked in the current month
    int checkedCount = _checkedDays.where((day) => day).length;

    // Update current month points and cases
    _points = checkedCount;
    int newCases = (_points / 6).floor(); // Case for every 6 points (change this logic as needed)
    if (newCases > _cases) {
      _incrementTotalCases(newCases - _cases); // Add new cases
    }
    _cases = newCases;

    setState(() {}); // Update the UI
  }

  Future<void> _fetchDataForMonth(DateTime date) async {
    final docId = '${date.year}_${date.month}'; // Document ID based on year and month
    final workoutDoc = FirebaseFirestore.instance.collection('workout_data').doc(docId);

    try {
      final snapshot = await workoutDoc.get();
      if (snapshot.exists) {
        final data = snapshot.data()!;
        List<bool> checkedDays = List<bool>.from(data['checkedDays']);

        // Set checked days for the month
        setState(() {
          _checkedDays = checkedDays;
          _points = (data['points'] ?? 0) as int; // Load points for the month
          _cases = (data['cases'] ?? 0) as int; // Load cases for the month
        });
      } else {
        // Reset for the new month if no document exists
        setState(() {
          _checkedDays = List.generate(31, (index) => false);
          _points = 0; // Reset points for the new month
          _cases = 0; // Reset cases for the new month
        });
      }
    } catch (e) {
      print('Error fetching workout data: $e');
    }
  }

  Future<void> _fetchTotalPoints() async {
    final totalDoc = FirebaseFirestore.instance.collection('workout_data').doc('total_data');

    try {
      final snapshot = await totalDoc.get();
      if (snapshot.exists) {
        final data = snapshot.data()!;
        setState(() {
          _totalPoints = (data['totalPoints'] ?? 0) as int; // Cast to int
        });
      }
    } catch (e) {
      print('Error fetching total points: $e');
    }
  }

  Future<void> _fetchTotalCases() async {
    final totalDoc = FirebaseFirestore.instance.collection('workout_data').doc('total_data');

    try {
      final snapshot = await totalDoc.get();
      if (snapshot.exists) {
        final data = snapshot.data()!;
        setState(() {
          _totalCases = (data['totalCases'] ?? 0) as int; // Cast to int
        });
      }
    } catch (e) {
      print('Error fetching total cases: $e');
    }
  }

  Future<void> _incrementTotalCases(int newCases) async {
    setState(() {
      _totalCases += newCases; // Update total cases locally
    });

    final totalDoc = FirebaseFirestore.instance.collection('workout_data').doc('total_data');

    try {
      await totalDoc.update({'totalCases': _totalCases}); // Update total cases in Firestore
    } catch (e) {
      print('Error updating total cases: $e');
    }
  }

  Future<void> _updateTotalPoints() async {
    final totalDoc = FirebaseFirestore.instance.collection('workout_data').doc('total_data');

    try {
      // Re-fetch all monthly points to recalculate total points
      int totalPoints = 0;
      final querySnapshot = await FirebaseFirestore.instance.collection('workout_data').get();
      for (var doc in querySnapshot.docs) {
        final data = doc.data();
        totalPoints += (data['points'] ?? 0) as int; // Cast to int
      }

      // Update total points in Firestore
      await totalDoc.update({'totalPoints': totalPoints}); // Update total points in Firestore
      setState(() {
        _totalPoints = totalPoints; // Update local total points
      });
    } catch (e) {
      print('Error updating total points: $e');
    }
  }

  Future<void> _saveCheckedDays() async {
    final docId = '${_selectedDate.year}_${_selectedDate.month}';
    final workoutDoc = FirebaseFirestore.instance.collection('workout_data').doc(docId);

    try {
      // Save the new points, cases, and checked days for the month
      await workoutDoc.set({
        'checkedDays': _checkedDays,
        'points': _points,
        'cases': _cases,
      });

      // Update total points and cases after saving current month's data
      await _updateTotalPoints(); // Update total points after saving current month's data
    } catch (e) {
      print('Error saving checked days: $e');
    }
  }
}
