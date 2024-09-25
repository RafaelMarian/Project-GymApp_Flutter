import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AchievementsPage extends StatelessWidget {
  const AchievementsPage({super.key});

  Future<Map<String, dynamic>?> _fetchLatestSleepData() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('sleep_data')
        .orderBy('timestamp', descending: true)
        .limit(1)
        .get();

    if (snapshot.docs.isNotEmpty) {
      return snapshot.docs.first.data();
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Achievements'),
        backgroundColor: const Color(0xFF29282C),
      ),
      backgroundColor: const Color(0xFF29282C),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: _fetchLatestSleepData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData) {
            return const Center(
              child: Text(
                'No recent sleep data available.',
                style: TextStyle(color: Colors.white),
              ),
            );
          }
          final sleepData = snapshot.data!;
          return Center(
            child: Text(
              'Last Sleep: ${sleepData['sleep_time']} to ${sleepData['wake_up_time']}'
              '\nDuration: ${sleepData['sleep_duration']}',
              style: const TextStyle(fontSize: 18, color: Colors.white),
              textAlign: TextAlign.center,
            ),
          );
        },
      ),
    );
  }
}
