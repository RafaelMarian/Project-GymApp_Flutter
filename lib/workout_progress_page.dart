import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart'; // Import for DateFormat
import 'flutter_month_picher.dart'; // Import the MonthPickerDialog

class WorkoutProgressPage extends StatefulWidget {
  const WorkoutProgressPage({super.key});

  @override
  _WorkoutProgressPageState createState() => _WorkoutProgressPageState();
}

class _WorkoutProgressPageState extends State<WorkoutProgressPage> {
  List<bool> _checkedDays = List.generate(31, (index) => false); // Assume 31 days
  DateTime _selectedDate = DateTime.now(); // Default to current date
  int points = 0; // Track user points
  int cases = 0; // Track number of cases

  @override
  void initState() {
    super.initState();
    _fetchDataForMonth(_selectedDate); // Fetch data for the default month
    _fetchPointsAndCases(); // Fetch points and cases from Firestore
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Workout Progress'),
        backgroundColor: const Color.fromARGB(255, 40, 39, 41),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Text(
                  'Points: $points | Cases: $cases',
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
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
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF7BB0E), // Custom color for "Select Month" button
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Select Month'),
                      content: MonthPickerDialog(
                        selectedDate: _selectedDate,
                        onChanged: (date) {
                          setState(() {
                            _selectedDate = date;
                            _fetchDataForMonth(date);
                          });
                        },
                      ),
                      actions: [
                        TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: const Color(0xFFF7BB0E), // Custom color for "Confirm" button
                          ),
                          onPressed: () {
                            Navigator.pop(context); // Close the dialog
                          },
                          child: const Text(
                            'Confirm',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.red, // Custom color for "Cancel" button
                          ),
                          onPressed: () {
                            Navigator.pop(context); // Close the dialog
                          },
                          child: const Text(
                            'Cancel',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
              child: const Text('Select Month'),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7, // 7 columns for days of the week
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                ),
                itemCount: _checkedDays.length,
                itemBuilder: (context, index) {
                  bool isCurrentDay = _selectedDate.month == DateTime.now().month &&
                      index + 1 == DateTime.now().day;

                  return GestureDetector(
                    onTap: isCurrentDay && !_checkedDays[index]
                        ? () => _confirmCheckBox(index)
                        : null,
                    child: Container(
                      decoration: BoxDecoration(
                        color: _checkedDays[index]
                            ? Colors.green
                            : isCurrentDay
                                ? Colors.grey[600]
                                : Colors.grey[800],
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
          ],
        ),
      ),
    );
  }

  Future<void> _fetchDataForMonth(DateTime date) async {
    final startDate = DateTime(date.year, date.month, 1);
    final endDate = DateTime(date.year, date.month + 1, 0);

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('workout_data')
          .where('timestamp', isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
          .where('timestamp', isLessThanOrEqualTo: Timestamp.fromDate(endDate))
          .get();

      List<bool> checkedDays = List.generate(31, (index) => false);

      for (var doc in snapshot.docs) {
        final data = doc.data();
        final timestamp = (data['timestamp'] as Timestamp).toDate();
        final day = timestamp.day;
        checkedDays[day - 1] = true; // Mark the day as checked
      }

      setState(() {
        _checkedDays = checkedDays;
      });
    } catch (e) {
      print('Error fetching workout data: $e');
    }
  }

  Future<void> _fetchPointsAndCases() async {
    try {
      final doc = await FirebaseFirestore.instance.collection('users').doc('user_id').get();
      if (doc.exists) {
        final data = doc.data()!;
        setState(() {
          points = data['points'] ?? 0;
          cases = data['cases'] ?? 0;
        });
      }
    } catch (e) {
      print('Error fetching points and cases: $e');
    }
  }

  Future<void> _savePointsAndCases() async {
    try {
      await FirebaseFirestore.instance.collection('users').doc('user_id').set({
        'points': points,
        'cases': cases,
      }, SetOptions(merge: true));
    } catch (e) {
      print('Error saving points and cases: $e');
    }
  }

  Future<void> _confirmCheckBox(int index) async {
    bool confirm = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirm Check'),
          content: const Text('Do you want to check this box?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );

    if (confirm) {
      setState(() {
        _checkedDays[index] = true;
        points++;
        if (points % 30 == 0) {
          cases++;
        }
        _saveCheckedDays();
        _savePointsAndCases();
      });
    }
  }

  Future<void> _saveCheckedDays() async {
    final startDate = DateTime(_selectedDate.year, _selectedDate.month, 1);
    final endDate = DateTime(_selectedDate.year, _selectedDate.month + 1, 0);

    try {
      // Remove existing entries for the selected month
      await FirebaseFirestore.instance
          .collection('workout_data')
          .where('timestamp', isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
          .where('timestamp', isLessThanOrEqualTo: Timestamp.fromDate(endDate))
          .get()
          .then((snapshot) {
        for (DocumentSnapshot ds in snapshot.docs) {
          ds.reference.delete();
        }
      });

      // Save the new checked days
      for (int i = 0; i < _checkedDays.length; i++) {
        if (_checkedDays[i]) {
          await FirebaseFirestore.instance.collection('workout_data').add({
            'timestamp': Timestamp.fromDate(DateTime(_selectedDate.year, _selectedDate.month, i + 1)),
            'checked': true,
          });
        }
      }
    } catch (e) {
      print('Error saving workout data: $e');
    }
  }
}
