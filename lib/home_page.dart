import 'package:flutter/material.dart';
import 'user_profile.dart';
import 'gym_program_selection_page.dart'; // Import GymProgramSelectionPage
import 'yoga_program_selection_page.dart'; // Import YogaProgramSelectionPage
import 'cycling_program_selection_page.dart'; // Import CyclingProgramSelectionPage
import 'jogging_program_selection_page.dart'; // Import JoggingProgramSelectionPage

class HomePage extends StatefulWidget {
  final UserProfile userProfile;

  HomePage({required this.userProfile});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedWorkoutType = 0;

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
                  child: _buildBox('Sleep Tracking', 'Details here'),
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
              icon: Icon(Icons.search, color: Colors.white),
              onPressed: () {
                // Handle search button press
              },
            ),
            IconButton(
              icon: Icon(Icons.notifications, color: Colors.white),
              onPressed: () {
                // Handle notifications button press
              },
            ),
            IconButton(
              icon: Icon(Icons.settings, color: Colors.white),
              onPressed: () {
                // Handle settings button press
              },
            ),
            IconButton(
              icon: Icon(Icons.person, color: Colors.white),
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
        color: Colors.grey[700],
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'Workout Progress',
            style: TextStyle(fontSize: 18, color: Colors.yellow),
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
            backgroundColor: Colors.grey[700],
          ),
          child: Text('Jogging'),
        ),
      ],
    );
  }

  Widget _buildExercisesSection() {
    return Center(
      child: Text(
        'Exercises for ${_getWorkoutTypeName()}',
        style: TextStyle(fontSize: 18, color: Colors.yellow),
      ),
    );
  }

  String _getWorkoutTypeName() {
    switch (_selectedWorkoutType) {
      case 0: return 'Gym';
      case 1: return 'Yoga';
      case 2: return 'Cycling';
      case 3: return 'Jogging';
      default: return '';
    }
  }
}
