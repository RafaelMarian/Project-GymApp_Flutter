import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class SleepInputPage extends StatefulWidget {
  const SleepInputPage({super.key});

  @override
  _SleepInputPageState createState() => _SleepInputPageState();
}

class _SleepInputPageState extends State<SleepInputPage> {
  TimeOfDay? sleepTime;
  TimeOfDay? wakeUpTime;
  DateTime? lastInputTime;
  bool canInput = true;

  @override
  void initState() {
    super.initState();
    _checkLastInputTime();
  }

  Future<void> _checkLastInputTime() async {
    // Fetch the last sleep entry time from Firestore or locally
    final snapshot = await FirebaseFirestore.instance
        .collection('sleep_data')
        .orderBy('timestamp', descending: true)
        .limit(1)
        .get();

    if (snapshot.docs.isNotEmpty) {
      final lastTime = snapshot.docs.first['timestamp'].toDate();
      setState(() {
        lastInputTime = lastTime;
        canInput = DateTime.now().difference(lastTime).inHours >= 16;
      });
    }
  }

  Future<void> _selectSleepTime(BuildContext context) async {
    if (!canInput) return;
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
    if (!canInput) return;
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
      // Confirm dialog before saving
      bool confirmed = await _confirmSaveDialog(sleepDuration);

      if (confirmed) {
        try {
          await FirebaseFirestore.instance.collection('sleep_data').add({
            'sleep_time': sleepTime?.format(context),
            'wake_up_time': wakeUpTime?.format(context),
            'sleep_duration': sleepDuration,
            'timestamp': Timestamp.now(),
          });

          setState(() {
            lastInputTime = DateTime.now();
            canInput = false; // Disable input for 16 hours
          });

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Sleep data saved successfully')),
          );
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error saving sleep data: $e')),
          );
        }
      }
    }
  }

  Future<bool> _confirmSaveDialog(String duration) async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Sleep Data'),
        content: Text('You slept for $duration. Is this correct?'),
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
      ),
    ) ?? false;
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
        title: const Text('Sleep Tracking', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF29282C),
      ),
      backgroundColor: const Color(0xFF29282C),
      body: canInput ? _buildInputForm(context) : _buildCooldownMessage(),
    );
  }

  Widget _buildInputForm(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ElevatedButton(
            onPressed: () => _selectSleepTime(context),
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFF7BB0E)),
            child: Text(
              sleepTime == null ? 'Set Sleep Time' : 'Sleep Time: ${sleepTime?.format(context)}',
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => _selectWakeUpTime(context),
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFF7BB0E)),
            child: Text(
              wakeUpTime == null ? 'Set Wake Up Time' : 'Wake Up Time: ${wakeUpTime?.format(context)}',
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _saveSleepData,
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFF7BB0E)),
            child: const Text('Save Sleep Data'),
          ),
        ],
      ),
    );
  }

  Widget _buildCooldownMessage() {
    final DateTime? nextInputTime = lastInputTime?.add(const Duration(hours: 16));
    return Center(
      child: Text(
        'You can input sleep data again at ${DateFormat('hh:mm a').format(nextInputTime!)}',
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
