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

      try {
        await FirebaseFirestore.instance.collection('sleep_data').add({
          'sleep_time': sleepTime?.format(context),
          'wake_up_time': wakeUpTime?.format(context),
          'sleep_duration': sleepDuration,
          'timestamp': Timestamp.now(),
        });

        Navigator.pop(context, sleepDuration);
      } catch (e) {
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
        title: const Text('Sleep Tracking', style: TextStyle(color: Color.fromARGB(255, 255, 255, 255))), // Very light cream
        backgroundColor: const Color.fromARGB(255, 40, 39, 41), // Dark teal
      ),
      backgroundColor: const Color.fromARGB(255, 40, 39, 41), // Lighter beige
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () => _selectSleepTime(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF7BB0E), // Warm, earthy beige
                minimumSize: const Size(200, 50),
                foregroundColor: const Color.fromARGB(255, 0, 0, 0), // Dark teal
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                sleepTime == null ? 'Set Sleep Time' : 'Sleep Time: ${sleepTime?.format(context)}',
                style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontSize: 16), // Very light cream
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _selectWakeUpTime(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF7BB0E), // Warm, earthy beige
                minimumSize: const Size(200, 50),
                foregroundColor: const Color.fromARGB(255, 0, 0, 0), // Dark teal
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                wakeUpTime == null ? 'Set Wake Up Time' : 'Wake Up Time: ${wakeUpTime?.format(context)}',
                style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontSize: 16), // Very light cream
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveSleepData,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF7BB0E), // Warm, earthy beige
                minimumSize: const Size(200, 50),
                foregroundColor: const Color.fromARGB(255, 0, 0, 0), // Dark teal
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Save Sleep Data',
                style: TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontSize: 16), // Very light cream
              ),
            ),
          ],
        ),
      ),
    );
  }
}
