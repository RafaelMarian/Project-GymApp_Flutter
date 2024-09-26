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

  @override
  void initState() {
    super.initState();
    _fetchDataForMonth(_selectedDate); // Fetch data for the default month
    _fetchTotalPoints(); // Fetch total points when the page loads
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
    _cases = (_points / 30).floor(); // Cases for the current month

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
          _points = data['points']; // Load points for the month
          _cases = data['cases']; // Load cases for the month
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
          _totalPoints = data['totalPoints'] ?? 0; // Load total points from Firebase
        });
      }
    } catch (e) {
      print('Error fetching total points: $e');
    }
  }

  Future<void> _saveCheckedDays() async {
    final docId = '${_selectedDate.year}_${_selectedDate.month}';
    final workoutDoc = FirebaseFirestore.instance.collection('workout_data').doc(docId);

    try {
      // Get the current month's document
      final snapshot = await workoutDoc.get();
      int previousPoints = 0;

      if (snapshot.exists) {
        final data = snapshot.data()!;
        previousPoints = data['points'] ?? 0; // Get previous points for this month
      }

      // Save the new points and checked days for the month
      await workoutDoc.set({
        'checkedDays': _checkedDays,
        'points': _points, // Save the new points
        'cases': _cases,   // Save cases for the month
      });

      // Calculate the difference in points
      int pointsDifference = _points - previousPoints;

      // Update total_data with the points difference
      final totalDoc = FirebaseFirestore.instance.collection('workout_data').doc('total_data');
      final totalSnapshot = await totalDoc.get();

      int currentTotalPoints = 0;

      if (totalSnapshot.exists) {
        final data = totalSnapshot.data()!;
        currentTotalPoints = data['totalPoints'] ?? 0; // Get current total points
      }

      // Add the points difference to the total points
      int newTotalPoints = currentTotalPoints + pointsDifference;

      // Save the updated total points
      await totalDoc.set({
        'totalPoints': newTotalPoints,
      });

      // Update the total points in the UI
      setState(() {
        _totalPoints = newTotalPoints;
      });

    } catch (e) {
      print('Error saving workout data: $e');
    }
  }
}
