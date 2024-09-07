import 'package:flutter/material.dart';
import 'user_profile.dart';
import 'gym_program_selection_page.dart'; // Import GymProgramSelectionPage

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
        _buildWorkoutButton('Gym', 0),
        _buildWorkoutButton('Yoga', 1),
        _buildWorkoutButton('Cycling', 2),
        _buildWorkoutButton('Jogging', 3),
      ],
    );
  }

  Widget _buildWorkoutButton(String text, int index) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor:
            _selectedWorkoutType == index ? Colors.yellow : Colors.grey[700],
      ),
      onPressed: () {
        if (index == 0) {
          // Gym button pressed
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => GymProgramSelectionPage(),
            ),
          );
        } else {
          setState(() {
            _selectedWorkoutType = index;
          });
        }
      },
      child: Text(text),
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
      case 0:
        return 'Gym';
      case 1:
        return 'Yoga';
      case 2:
        return 'Cycling';
      case 3:
        return 'Jogging';
      default:
        return '';
    }
  }
}
