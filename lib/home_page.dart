import 'package:flutter/material.dart';
import 'user_profile.dart';
import 'gym_program_selection_page.dart';
import 'yoga_program_selection_page.dart';
import 'cycling_program_selection_page.dart';
import 'jogging_program_selection_page.dart';
import 'sleep_input_page.dart';
import 'water_tracking_page.dart'; // Import WaterTrackingPage
import 'steps_counter.dart'; // Import StepsTrackingPage
import 'package:cloud_firestore/cloud_firestore.dart';
import 'user_id_page.dart'; // Import the new User ID page

class HomePage extends StatefulWidget {
  final UserProfile userProfile;

  const HomePage({super.key, required this.userProfile});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _sleepDuration = 'Not available';
  double _sleepRating = 0.0;

  @override
  void initState() {
    super.initState();
    _fetchSleepData();
  }

  Future<void> _fetchSleepData() async {
    final now = DateTime.now();
    final startDate = now.subtract(const Duration(days: 7));

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('sleep_data')
          .where('timestamp', isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
          .orderBy('timestamp', descending: true)
          .limit(7)
          .get();

      List<int> sleepDurations = [];
      int totalSleep = 0;
      int count = 0;

      for (var doc in snapshot.docs) {
        final data = doc.data();
        final duration = data['sleep_duration'] as String?;

        if (duration != null) {
          final parts = duration.split(':');
          final hours = int.parse(parts[0]);
          final minutes = int.parse(parts[1]);
          final totalMinutes = (hours * 60) + minutes;

          sleepDurations.add(totalMinutes);
          totalSleep += totalMinutes;
          count++;
        }
      }

      if (count > 0) {
        final averageSleep = totalSleep / count / 60; // Convert minutes to hours
        setState(() {
          _sleepDuration = '${averageSleep.toStringAsFixed(2)} hours';
          _sleepRating = _calculateSleepRating(sleepDurations);
        });
      }
    } catch (e) {
      print('Error fetching sleep data: $e');
    }
  }

  double _calculateSleepRating(List<int> durations) {
    if (durations.isEmpty) return 0.0;

    int idealSleepMinutes = 8 * 60; // 8 hours in minutes
    int totalMinutes = durations.reduce((a, b) => a + b);
    double averageSleep = totalMinutes / durations.length;

    double rating = (averageSleep / idealSleepMinutes) * 100;
    if (averageSleep > idealSleepMinutes) {
      rating -= (averageSleep - idealSleepMinutes) * 0.5;
    }
    return rating.clamp(0, 100);
  }

  Widget _buildSleepTrackingBox() {
    Color lineColor;
    final double sleepHours = _parseSleepDuration(_sleepDuration);

    if (sleepHours >= 8) {
      lineColor = Colors.green;
    } else if (sleepHours >= 7) {
      lineColor = Colors.orange;
    } else {
      lineColor = Colors.red;
    }

    return GestureDetector(
      onTap: () async {
        final sleepDuration = await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SleepInputPage()),
        );

        if (sleepDuration != null) {
          _fetchSleepData(); // Refresh sleep data
        }
      },
      child: Container(
        child: Card(
          color: const Color.fromARGB(255, 10, 10, 10), // Dark background for sleep tracking box
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Sleep Tracking',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
                const SizedBox(height: 10),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final width = constraints.maxWidth * (_parseSleepDuration(_sleepDuration) / 8).clamp(0.0, 1.0);
                    return Container(
                      height: 20,
                      color: lineColor,
                      width: width,
                    );
                  },
                ),
                const SizedBox(height: 10),
                Text(
                  'Sleep Rating: ${_sleepRating.toStringAsFixed(1)}%',
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  double _parseSleepDuration(String duration) {
    final parts = duration.split(' ');
    if (parts.length > 1) {
      final hours = double.tryParse(parts[0]) ?? 0;
      final minutes = double.tryParse(parts[1]) ?? 0;
      return hours + minutes / 60;
    }
    return 0.0;
  }

  void _showUserId() {
    final userId = widget.userProfile.id;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserIdPage(userId: userId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.userProfile.name),
        backgroundColor: const Color(0xFF29282C), // Dark background for app bar
      ),
      backgroundColor: const Color(0xFF29282C), // Dark background for the page
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWorkoutProgressBox(),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>const StepsCounterPage()), // Navigate to StepsTrackingPage
                      );
                    },
                    child: _buildBox('Steps Counted', 'Track your steps'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildSleepTrackingBox(),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _buildBox('Calories Burned', 'Details here'),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>const WaterTrackingPage()), // Navigate to WaterTrackingPage
                      );
                    },
                    child: _buildBox('Water Tracking', 'Set and track your goal'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildWorkoutTypeButtons(),
            const SizedBox(height: 20),
            _buildExercisesSection(),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: _showUserId,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF7BB0E), // Yellow color for Show User ID button
                ),
                child: const Text('Show User ID', style: TextStyle(color: Colors.black)),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: const Color(0xFF29282C), // Dark background for bottom app bar
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(Icons.home, color: Color(0xFFF7BB0E)),
              onPressed: () {
                // Handle home button press
              },
            ),
            IconButton(
              icon: const Icon(Icons.search, color: Color(0xFFF7BB0E)),
              onPressed: () {
                // Handle search button press
              },
            ),
            IconButton(
              icon: const Icon(Icons.notifications, color: Color(0xFFF7BB0E)),
              onPressed: () {
                // Handle notifications button press
              },
            ),
            IconButton(
              icon: const Icon(Icons.settings, color: Color(0xFFF7BB0E)),
              onPressed: () {
                // Handle settings button press
              },
            ),
            IconButton(
              icon: const Icon(Icons.person, color: Color(0xFFF7BB0E)),
              onPressed: () {
                // Handle profile button press
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWorkoutProgressBox() {
    return const SizedBox(
      width: double.infinity,
      child: Card(
        color: Color(0xFFF7BB0E), // Yellow background for workout progress box
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'Workout Progress',
            style: TextStyle(fontSize: 18, color: Colors.black),
          ),
        ),
      ),
    );
  }

  Widget _buildBox(String title, String details) {
    return Card(
      color: const Color(0xFF29282C), // Dark background for boxes
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, color: Colors.white),
            ),
            const SizedBox(height: 10),
            Text(
              details,
              style: const TextStyle(fontSize: 14, color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWorkoutTypeButtons() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const GymProgramSelectionPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF7BB0E), // Yellow color for buttons
                ),
                child: const Text('Gym Program', style: TextStyle(color: Colors.black)),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const YogaProgramSelectionPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF7BB0E), // Yellow color for buttons
                ),
                child: const Text('Yoga Program', style: TextStyle(color: Colors.black)),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CyclingProgramSelectionPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF7BB0E), // Yellow color for buttons
                ),
                child: const Text('Cycling Program', style: TextStyle(color: Colors.black)),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const JoggingProgramSelectionPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF7BB0E), // Yellow color for buttons
                ),
                child: const Text('Jogging Program', style: TextStyle(color: Colors.black)),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildExercisesSection() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Exercises',
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
        // Placeholder for exercises
        SizedBox(height: 10),
        Card(
          color: Color(0xFF29282C), // Dark background for exercises section
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'No exercises added yet.',
              style: TextStyle(fontSize: 16, color: Colors.white70),
            ),
          ),
        ),
      ],
    );
  }
}
