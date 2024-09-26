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
  int _points = 0; // Points for checked days
  int _cases = 0; // 1 case for every 30 points
  int _checkedCount = 0; // Count of checked boxes

  @override
  void initState() {
    super.initState();
    _fetchDataForMonth(_selectedDate); // Fetch data for the default month
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
            // Move the points, cases, and checked count below the grid
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
                      'Checked: $_checkedCount',
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
    // Count how many boxes are checked
    _checkedCount = _checkedDays.where((day) => day == true).length;
    _points = _checkedCount;
    _cases = (_points / 30).floor(); // 1 case for every 30 points

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
        int points = data['points'];
        int cases = data['cases'];
        int checkedCount = data['checkedCount'];

        setState(() {
          _checkedDays = checkedDays;
          _points = points;
          _cases = cases;
          _checkedCount = checkedCount;
        });
      }
    } catch (e) {
      print('Error fetching workout data: $e');
    }
  }

  Future<void> _saveCheckedDays() async {
    final docId = '${_selectedDate.year}_${_selectedDate.month}';
    final workoutDoc = FirebaseFirestore.instance.collection('workout_data').doc(docId);

    try {
      await workoutDoc.set({
        'checkedDays': _checkedDays,
        'points': _points,
        'cases': _cases,
        'checkedCount': _checkedCount,
      });
    } catch (e) {
      print('Error saving workout data: $e');
    }
  }
}
