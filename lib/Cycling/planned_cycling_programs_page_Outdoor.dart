import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PlannedCyclingProgramsPageOutdoor extends StatefulWidget {
  const PlannedCyclingProgramsPageOutdoor({super.key});

  @override
  _PlannedCyclingProgramsPageStateOutdoor createState() => _PlannedCyclingProgramsPageStateOutdoor();
}

class _PlannedCyclingProgramsPageStateOutdoor extends State<PlannedCyclingProgramsPageOutdoor> {
  String? selectedDifficulty;
  Map<String, dynamic>? workoutRoutine;

  // Fetch workout plan based on selected difficulty
  Future<void> _fetchWorkoutPlan() async {
    if (selectedDifficulty != null) {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('planned_cycling_programs_outdoor')
          .where('difficulty', isEqualTo: selectedDifficulty)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        setState(() {
          workoutRoutine = querySnapshot.docs.first.data();
        });
      } else {
        setState(() {
          workoutRoutine = null;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Planned Cycling Programs'),
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
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _fetchWorkoutPlan,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF7BB0E),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12), // Rounded corners
                ),
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
              ),
              child: const Text(
                'Fetch Cycling Plan',
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: workoutRoutine != null
                  ? ListView.builder(
                      itemCount: workoutRoutine!['days'].length,
                      itemBuilder: (context, index) {
                        // Get the day name and its details
                        String dayName = workoutRoutine!['days'].keys.elementAt(index);
                        final day = workoutRoutine!['days'][dayName];
                        
                        // Each day has details like duration, intensity, etc.
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
                                Text(
                                  'Duration: ${day['duration']}',
                                  style: const TextStyle(color: Colors.white),
                                ),
                                Text(
                                  'Intensity: ${day['intensity']}',
                                  style: const TextStyle(color: Colors.white),
                                ),
                                if (day['intervals'] != null) ...[
                                  const SizedBox(height: 8),
                                  const Text(
                                    'Intervals:',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Color(0xFFF7BB0E),
                                    ),
                                  ),
                                  ...List.generate((day['intervals'] as List).length, (i) {
                                    final interval = day['intervals'][i];
                                    return Text(
                                      '${interval['work']} at ${interval['effort']}%, Recovery: ${interval['recovery']}',
                                      style: const TextStyle(color: Colors.white),
                                    );
                                  }),
                                ]
                              ],
                            ),
                          ),
                        );
                      },
                    )
                  : const Center(
                      child: Text(
                        'No workout plan selected.',
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
