import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SleepInputPage extends StatefulWidget {
  const SleepInputPage({super.key});

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
    return '${duration.inHours.toString().padLeft(2, '0')}:${(duration.inMinutes % 60).toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sleep Tracking'),
        backgroundColor: Colors.grey[800],
      ),
      backgroundColor: Colors.grey[800],
      body: Center( // Center the content
        child: Column(
          mainAxisSize: MainAxisSize.min, // Center the column vertically
          children: [
            ElevatedButton(
              onPressed: () => _selectSleepTime(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow, // Button color
                minimumSize: const Size(200, 50), // Smaller button size
              ),
              child: Text(
                sleepTime == null ? 'Set Sleep Time' : 'Sleep Time: ${sleepTime?.format(context)}',
                style: const TextStyle(color: Colors.black, fontSize: 16), // Adjusted text size
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _selectWakeUpTime(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow, // Button color
                minimumSize: const Size(200, 50), // Smaller button size
              ),
              child: Text(
                wakeUpTime == null ? 'Set Wake Up Time' : 'Wake Up Time: ${wakeUpTime?.format(context)}',
                style: const TextStyle(color: Colors.black, fontSize: 16), // Adjusted text size
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveSleepData,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow, // Button color
                minimumSize: const Size(200, 50), // Smaller button size
              ),
              child: const Text(
                'Save Sleep Data',
                style: TextStyle(color: Colors.black, fontSize: 16), // Adjusted text size
              ),
            ),
          ],
        ),
      ),
    );
  }
}
