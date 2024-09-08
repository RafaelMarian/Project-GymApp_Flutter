import 'package:flutter/material.dart';
import 'user_profile.dart';
import 'gym_program_selection_page.dart'; // Import GymProgramSelectionPage
import 'yoga_program_selection_page.dart'; // Import YogaProgramSelectionPage
import 'cycling_program_selection_page.dart'; // Import CyclingProgramSelectionPage
import 'jogging_program_selection_page.dart'; // Import JoggingProgramSelectionPage
import 'sleep_input_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart'; // Ensure Firebase is initialized


class HomePage extends StatefulWidget {
  final UserProfile userProfile;

  HomePage({required this.userProfile});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedWorkoutType = 0;
  String _sleepDuration = 'Not available';
  double _sleepRating = 0.0;

  @override
  void initState() {
    super.initState();
    _fetchSleepData();
  }

  Future<void> _fetchSleepData() async {
    final now = DateTime.now();
    final startDate = now.subtract(Duration(days: 7));

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
      _sleepDuration = '${averageSleep.toStringAsFixed(2)} hours';
      _sleepRating = _calculateSleepRating(sleepDurations);
    }
    
    setState(() {});
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
      lineColor = Colors.red;
    } else if (sleepHours >= 7) {
      lineColor = Colors.green;
    } else if (sleepHours >= 6) {
      lineColor = Colors.orange;
    } else {
      lineColor = Colors.red;
    }

    return GestureDetector(
      onTap: () async {
        final sleepDuration = await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SleepInputPage()), // Navigate to SleepInputPage
        );

        if (sleepDuration != null) {
          _fetchSleepData(); // Refresh sleep data
        }
      },
      child: Container(
      width: double.infinity,
      child: Card(
        color: Colors.yellow,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Sleep Tracking',
                style: TextStyle(fontSize: 18, color: Colors.black),
              ),
              SizedBox(height: 10),
              Text(
                'Duration: $_sleepDuration',
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
              SizedBox(height: 10),
              Container(
                height: 20,
                color: lineColor,
                width: double.infinity * (sleepHours / 8),
              ),
              SizedBox(height: 10),
              Text(
                'Sleep Rating: ${_sleepRating.toStringAsFixed(1)}%',
                style: TextStyle(fontSize: 16, color: Colors.black),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.userProfile.name),
        backgroundColor: Colors.grey[800],
      ),
      backgroundColor: Colors.grey[800],
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWorkoutProgressBox(),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _buildBox('Steps Counted', 'Details here'),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: _buildSleepTrackingBox(),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _buildBox('Calories Burned', 'Details here'),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: _buildBox('Fitness News', 'Latest news here'),
                ),
              ],
            ),
            SizedBox(height: 20),
            _buildWorkoutTypeButtons(),
            SizedBox(height: 20),
            _buildExercisesSection(),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.grey[800], // Set the background color to grey
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: Icon(Icons.home, color: Colors.yellow),
              onPressed: () {
                // Handle home button press
              },
            ),
            IconButton(
              icon: Icon(Icons.search, color: Colors.yellow),
              onPressed: () {
                // Handle search button press
              },
            ),
            IconButton(
              icon: Icon(Icons.notifications, color: Colors.yellow),
              onPressed: () {
                // Handle notifications button press
              },
            ),
            IconButton(
              icon: Icon(Icons.settings, color: Colors.yellow),
              onPressed: () {
                // Handle settings button press
              },
            ),
            IconButton(
              icon: Icon(Icons.person, color: Colors.yellow),
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
    return Container(
      width: double.infinity,
      child: Card(
        color: Colors.yellow,
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
      color: Colors.grey[700],
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 18, color: Colors.yellow),
            ),
            SizedBox(height: 10),
            Text(
              details,
              style: TextStyle(fontSize: 16, color: Colors.yellow),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWorkoutTypeButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => GymProgramSelectionPage(), // Navigate to Gym selection page
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.yellow,
          ),
          child: Text('Gym'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => YogaProgramSelectionPage(), // Navigate to Yoga selection page
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.yellow,
          ),
          child: Text('Yoga'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CyclingProgramSelectionPage(), // Navigate to Cycling selection page
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.yellow,
          ),
          child: Text('Cycling'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => JoggingProgramSelectionPage(), // Navigate to Jogging selection page
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.yellow,
          ),
          child: Text('Jogging'),
        ),
      ],
    );
  }

  Widget _buildExercisesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Exercises',
          style: TextStyle(fontSize: 18, color: Colors.yellow),
        ),
        SizedBox(height: 10),
        // Add your exercise widgets here
      ],
    );
  }
}

