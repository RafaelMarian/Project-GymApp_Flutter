import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PlannedYogaProgramsPage extends StatefulWidget {
  const PlannedYogaProgramsPage({super.key});

  @override
  _PlannedYogaProgramsPageState createState() => _PlannedYogaProgramsPageState();
}

class _PlannedYogaProgramsPageState extends State<PlannedYogaProgramsPage> {
  String? selectedDifficulty;
  String? selectedWorkoutType;
  Map<String, dynamic>? yogaRoutine;

  // Fetch yoga plan based on selected criteria
  Future<void> _fetchYogaPlan() async {
    if (selectedDifficulty != null && selectedWorkoutType != null) {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('planned_yoga_programs')
          .where('difficulty', isEqualTo: selectedDifficulty)
          .where('workout_type', isEqualTo: selectedWorkoutType)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        setState(() {
          yogaRoutine = querySnapshot.docs.first.data();
        });
      } else {
        setState(() {
          yogaRoutine = null;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Planned Yoga Programs'),
        backgroundColor: const Color.fromARGB(255, 40, 39, 41),
      ),
      backgroundColor: const Color.fromARGB(255, 40, 39, 41),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Dropdown for difficulty
            _buildDropdown(
              'Select Difficulty',
              selectedDifficulty,
              ['Beginner', 'Intermediate', 'Advanced'],
              (newValue) {
                setState(() {
                  selectedDifficulty = newValue;
                });
              },
            ),
            const SizedBox(height: 16),
            // Dropdown for workout type
            _buildDropdown(
              'Select Workout Type',
              selectedWorkoutType,
              ['Full Body', 'Relaxing', 'Power Yoga', 'Custom'],
              (newValue) {
                setState(() {
                  selectedWorkoutType = newValue;
                });
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _fetchYogaPlan,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF7BB0E),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12), // Rounded corners
                ),
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
              ),
              child: const Text(
                'Fetch Yoga Plan',
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: yogaRoutine != null && yogaRoutine!['days'] != null
                  ? ListView.builder(
                      itemCount: (yogaRoutine!['days'] as Map).length,
                      itemBuilder: (context, index) {
                        // Get the day name and its details
                        String dayName = yogaRoutine!['days'].keys.elementAt(index);
                        final day = yogaRoutine!['days'][dayName] as Map?;
                        final exercises = day != null && day['exercises'] != null
                            ? day['exercises'] as List
                            : [];

                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          color: Colors.grey[850],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 3,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  dayName,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    color: Color(0xFFF7BB0E),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                ...exercises.map<Widget>((exercise) {
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 4.0),
                                    child: Text(
                                      '${exercise['name']} - ${exercise['time']} minutes',
                                      style: const TextStyle(color: Colors.white),
                                    ),
                                  );
                                }),
                              ],
                            ),
                          ),
                        );
                      },
                    )
                  : const Center(
                      child: Text(
                        'No yoga plan found for the selected criteria.',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  // Reusable Dropdown Builder
  Widget _buildDropdown(
    String hint,
    String? selectedValue,
    List<String> items,
    ValueChanged<String?> onChanged,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButton<String>(
        value: selectedValue,
        isExpanded: true,
        dropdownColor: Colors.grey[900],
        hint: Text(hint, style: const TextStyle(color: Colors.white)),
        items: items.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value, style: const TextStyle(color: Colors.white)),
          );
        }).toList(),
        onChanged: onChanged,
        underline: const SizedBox(), // Removes the default underline
        icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
      ),
    );
  }
}
