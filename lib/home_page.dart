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
  String _sleepDuration = '0';
  double _sleepRating = 0.0;
  final PageController _pageController = PageController(viewportFraction: 0.8);
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _fetchSleepData();

    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page!.round();
      });
    });
  }

  Future<void> _fetchSleepData() async {
    setState(() {
      _sleepDuration = '6.5';
      _sleepRating = 81.0;
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
          _fetchSleepData();
        }
      },
      child: Container(
        child: Card(
          color: const Color(0xFFF7BB0E),
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
            Row(
              children: [
                Expanded(
                  child: _buildWorkoutProgressBox(),
                ),
                const SizedBox(width: 10),
                SizedBox(
                  width: 60, // Set a fixed width for the ID box (or your desired width)
                  child: _buildShowUserIdBox(), // ID button moved next to Workout Progress
                ),
              ],
            ),
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
                  child: _buildSleepTrackingBox(),
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
            _buildWorkoutTypeSlideshow(),
            const SizedBox(height: 20),
            _buildLargeBoxes(),
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

// New "ID" box next to "Workout Progress" with reduced width (left to right)
Widget _buildShowUserIdBox() {
  return GestureDetector(
    onTap: _showUserId,
    child: Container(
      width: 60, // Set a fixed width for the ID box
      child: Card(
        color: const Color(0xFFF7BB0E),
        child: const Padding(
          padding: EdgeInsets.all(16.0),
          child: Center(
            child: Text(
              'ID',
              style: TextStyle(fontSize: 18, color: Colors.black),
            ),
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

  Widget _buildWorkoutTypeSlideshow() {
    return SizedBox(
      height: 150,
      child: PageView.builder(
        controller: _pageController,
        itemCount: 5, // Gym, Yoga, Cycling, Jogging, and Custom Programs
        itemBuilder: (context, index) {
          return _buildWorkoutSlide(index == _currentPage, index);
        },
      ),
    );
  }

  Widget _buildWorkoutSlide(bool active, int index) {
    final workouts = ['Gym Program', 'Yoga Program', 'Cycling Program', 'Jogging Program', 'Custom Programs'];
    final pages = [
      const GymProgramSelectionPage(),
      const YogaProgramSelectionPage(),
      const CyclingProgramSelectionPage(),
      const JoggingProgramSelectionPage(),
      const CustomProgramsPage(),
    ];

    final double blur = active ? 20 : 0;
    final double scale = active ? 1.0 : 0.9;

    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => pages[index]));
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        transform: Matrix4.identity()..scale(scale),
        decoration: BoxDecoration(
          color: const Color(0xFFF7BB0E),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black87, blurRadius: blur)],
        ),
        child: Center(
          child: Text(
            workouts[index],
            style: const TextStyle(fontSize: 18, color: Colors.black),
          ),
        ),
      ),
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
