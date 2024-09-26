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
                        _checkedDays[index] = !_checkedDays[index];
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

  Future<void> _saveCheckedDays() async {
    final startDate = DateTime(_selectedDate.year, _selectedDate.month, 1);
    final endDate = DateTime(_selectedDate.year, _selectedDate.month + 1, 0);

    try {
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
