import 'package:flutter/material.dart';
import 'user_profile.dart';
import 'gym_program_selection_page.dart';
import 'yoga_program_selection_page.dart';
import 'cycling_program_selection_page.dart';
import 'jogging_program_selection_page.dart';
import 'your_ai_page.dart';
import 'nutrition_page.dart';
import 'achievements_page.dart';
import 'stretching_page.dart';
import 'sleep_input_page.dart';
import 'workout_progress_page.dart';
import 'steps_counter.dart';
import 'user_id_page.dart';
import 'custom_programs_page.dart';
import 'water_tracking_page.dart';
import 'calories_page.dart';

class HomePage extends StatefulWidget {
  final UserProfile userProfile;

  const HomePage({super.key, required this.userProfile});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _sleepDuration = '0'; // Changed default value for better calculation
  double _sleepRating = 0.0;

  @override
  void initState() {
    super.initState();
    _fetchSleepData();
  }

  Future<void> _fetchSleepData() async {
    // Replace with your actual logic to fetch and calculate sleep data
    setState(() {
      // Mock data for testing purposes
      _sleepDuration = '6.5'; // Example duration in hours
      _sleepRating = 81.0; // Example sleep rating percentage
    });
  }

  Widget _buildSleepTrackingBox() {
    return GestureDetector(
      onTap: () async {
        final updatedData = await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SleepInputPage()),
        );

        if (updatedData != null) {
          setState(() {
            _sleepDuration = updatedData['duration'] ?? '0';
            _sleepRating = updatedData['rating'] ?? 0.0;
          });
          _fetchSleepData(); // Refresh sleep data
        }
      },
      child: Container(
        child: Card(
          color: const Color(0xFFF7BB0E), // Yellow background
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Sleep Tracking',
                  style: TextStyle(fontSize: 18, color: Color.fromARGB(255, 0, 0, 0)),
                ),
                const SizedBox(height: 10),
                // Sleep progress bar
                LayoutBuilder(
                  builder: (context, constraints) {
                    final width = constraints.maxWidth * (_parseSleepDuration(_sleepDuration) / 8).clamp(0.0, 1.0);
                    return Container(
                      height: 20,
                      color: _getSleepProgressColor(),
                      width: width,
                    );
                  },
                ),
                const SizedBox(height: 10),
                Text(
                  'Sleep Rating: ${_sleepRating.toStringAsFixed(1)}%',
                  style: const TextStyle(fontSize: 16, color: Color.fromARGB(255, 0, 0, 0)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getSleepProgressColor() {
    final double sleepHours = _parseSleepDuration(_sleepDuration);
    if (sleepHours >= 8) {
      return Colors.green;
    } else if (sleepHours >= 7) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }

  double _parseSleepDuration(String duration) {
    final double? parsed = double.tryParse(duration);
    return parsed ?? 0.0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.userProfile.name),
        backgroundColor: const Color.fromARGB(255, 40, 39, 41),
      ),
      backgroundColor: const Color.fromARGB(255, 40, 39, 41),
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
                  child: _buildBox('Steps Counted', 'Set and Track your steps', () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const StepsCounterPage()),
                    );
                  }),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildSleepTrackingBox(), // Updated Sleep Tracking
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _buildBox('Calories Burned', 'Track and set your calories', () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const InventoryPage()),
                    );
                  }),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildBox('Water Tracking', 'Track your water intake', () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const WaterTrackingPage()),
                    );
                  }),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildWorkoutTypeButtons(),
            const SizedBox(height: 20),
            _buildLargeBoxes(),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CustomProgramsPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF7BB0E),
                ),
                child: const Text('Custom Programs', style: TextStyle(color: Colors.black)),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: _showUserId,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF7BB0E),
                ),
                child: const Text('Show User ID', style: TextStyle(color: Colors.black)),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildWorkoutProgressBox() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const WorkoutProgressPage()),
        );
      },
      child: const SizedBox(
        width: double.infinity,
        child: Card(
          color: Color(0xFFF7BB0E),
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Workout Progress',
              style: TextStyle(fontSize: 18, color: Colors.black),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBox(String title, String details, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: const Color.fromARGB(255, 0, 0, 0),
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
                  backgroundColor: const Color(0xFFF7BB0E),
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
                  backgroundColor: const Color(0xFFF7BB0E),
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
                  backgroundColor: const Color(0xFFF7BB0E),
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
                  backgroundColor: const Color(0xFFF7BB0E),
                ),
                child: const Text('Jogging Program', style: TextStyle(color: Colors.black)),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLargeBoxes() {
    return Row(
      children: [
        Expanded(
          child: _buildLargeBox('Your AI', const YourAIPage()),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: _buildLargeBox('Diet', const NutritionPage()),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: _buildLargeBox('Goals', const AchievementsPage()),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: _buildLargeBox('Stretch', const StretchingPage()),
        ),
        const SizedBox(width: 6),
      ],
    );
  }

  Widget _buildLargeBox(String title, Widget page) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => page));
      },
      child: Card(
        color: const Color.fromARGB(255, 0, 0, 0),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 16, color: Colors.white),
              ),
              const SizedBox(height: 5),
              const Text(
                'Click to explore',
                style: TextStyle(fontSize: 8, color: Colors.white70),
              ),
            ],
          ),
        ),
      ),
    );
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

  Widget _buildBottomNavigationBar() {
    return BottomAppBar(
      color: const Color(0xFF29282C),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            icon: const Icon(Icons.home, color: Color(0xFFF7BB0E)),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HomePage(userProfile: widget.userProfile)),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.fitness_center, color: Color(0xFFF7BB0E)),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const WorkoutProgressPage()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.account_circle, color: Color(0xFFF7BB0E)),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AchievementsPage()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.restaurant, color: Color(0xFFF7BB0E)),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const NutritionPage()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.chat, color: Color(0xFFF7BB0E)),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const YourAIPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}

