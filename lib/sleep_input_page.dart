import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class SleepInputPage extends StatefulWidget {
  @override
  _SleepInputPageState createState() => _SleepInputPageState();
}

class _SleepInputPageState extends State<SleepInputPage> {
  TimeOfDay? sleepTime;
  TimeOfDay? wakeUpTime;

  Future<void> _selectSleepTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: sleepTime ?? TimeOfDay.now(),
    );
    if (picked != null && picked != sleepTime) {
      setState(() {
        sleepTime = picked;
      });
    }
  }

  Future<void> _selectWakeUpTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: wakeUpTime ?? TimeOfDay.now(),
    );
    if (picked != null && picked != wakeUpTime) {
      setState(() {
        wakeUpTime = picked;
      });
    }
  }

  Future<void> _saveSleepData() async {
    if (sleepTime != null && wakeUpTime != null) {
      final sleepDuration = calculateSleepDuration(sleepTime!, wakeUpTime!);

      // Save to Firebase
      try {
        await FirebaseFirestore.instance.collection('sleep_data').add({
          'sleep_time': sleepTime?.format(context),
          'wake_up_time': wakeUpTime?.format(context),
          'sleep_duration': sleepDuration,
          'timestamp': Timestamp.now(),
        });

        Navigator.pop(context, sleepDuration);
      } catch (e) {
        // Handle any errors
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving sleep data: $e')),
        );
      }
    }
  }

  String calculateSleepDuration(TimeOfDay sleep, TimeOfDay wakeUp) {
    final now = DateTime.now();
    final sleepDateTime = DateTime(now.year, now.month, now.day, sleep.hour, sleep.minute);
    final wakeUpDateTime = DateTime(now.year, now.month, now.day, wakeUp.hour, wakeUp.minute);

    final duration = wakeUpDateTime.difference(sleepDateTime);
    return duration.inHours.toString().padLeft(2, '0') + ':' + (duration.inMinutes % 60).toString().padLeft(2, '0');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sleep Tracking'),
        backgroundColor: Colors.grey[800],
      ),
      backgroundColor: Colors.grey[800],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => _selectSleepTime(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow, // Button color
                minimumSize: Size(250, 60), // Larger button size
              ),
              child: Text(
                sleepTime == null ? 'Set Sleep Time' : 'Sleep Time: ${sleepTime?.format(context)}',
                style: TextStyle(color: Colors.black, fontSize: 18), // Larger text
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _selectWakeUpTime(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow, // Button color
                minimumSize: Size(250, 60), // Larger button size
              ),
              child: Text(
                wakeUpTime == null ? 'Set Wake Up Time' : 'Wake Up Time: ${wakeUpTime?.format(context)}',
                style: TextStyle(color: Colors.black, fontSize: 18), // Larger text
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveSleepData,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow, // Button color
                minimumSize: Size(250, 60), // Larger button size
              ),
              child: Text(
                'Save Sleep Data',
                style: TextStyle(color: Colors.black, fontSize: 18), // Larger text
              ),
            ),
          ],
        ),
      ),
    );
  }
}
