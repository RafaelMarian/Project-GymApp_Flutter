import 'package:flutter/material.dart';
import 'custom_yoga_program_page.dart';
import 'planned_yoga_programs_page.dart';
import 'my_personal_trainer_plan_yoga_page.dart'; // Import Personal Trainer Plan page

class YogaProgramSelectionPage extends StatefulWidget {
  const YogaProgramSelectionPage({super.key});

  @override
  _YogaProgramSelectionPageState createState() =>
      _YogaProgramSelectionPageState();
}

class _YogaProgramSelectionPageState extends State<YogaProgramSelectionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Yoga Program Selection'),
        backgroundColor: Colors.grey[800],
      ),
      backgroundColor: Colors.grey[800],
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CustomYogaProgramPage(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow,
                minimumSize: const Size(200, 50),
              ),
              child: const Text('Custom Program'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PlannedYogaProgramsPage(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow,
                minimumSize: const Size(200, 50),
              ),
              child: const Text('Planned Programs'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MyPersonalTrainerPlanYogaPage(), // Navigate to "My Personal Trainer Plan"
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow,
                minimumSize: const Size(200, 50),
              ),
              child: const Text('My Personal Trainer Plan'),
            ),
          ],
        ),
      ),
    );
  }
}
