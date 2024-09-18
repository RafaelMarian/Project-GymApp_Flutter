import 'package:flutter/material.dart';
import 'custom_cycling_program_page.dart';
import 'planned_cycling_programs_page.dart';
import 'my_personal_trainer_plan_cycling_page.dart'; // Import Personal Trainer Plan page

class CyclingProgramSelectionPage extends StatefulWidget {
  const CyclingProgramSelectionPage({super.key});

  @override
  _CyclingProgramSelectionPageState createState() =>
      _CyclingProgramSelectionPageState();
}

class _CyclingProgramSelectionPageState extends State<CyclingProgramSelectionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cycling Program Selection'),
        backgroundColor: Color.fromARGB(255, 40, 39, 41),
      ),
      backgroundColor: Color.fromARGB(255, 40, 39, 41),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CustomCyclingProgramPage(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFF7BB0E),
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
                    builder: (context) => const PlannedCyclingProgramsPage(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFF7BB0E),
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
                    builder: (context) => const MyPersonalTrainerPlanCyclingPage(), // Navigate to "My Personal Trainer Plan"
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFF7BB0E),
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
