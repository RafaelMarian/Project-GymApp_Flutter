import 'package:flutter/material.dart';
import 'custom_cycling_program_page.dart';
import 'planned_cycling_programs_page.dart';
import 'my_personal_trainer_plan_cycling_page.dart'; // Import Personal Trainer Plan page

class CyclingProgramSelectionPage extends StatefulWidget {
  @override
  _CyclingProgramSelectionPageState createState() =>
      _CyclingProgramSelectionPageState();
}

class _CyclingProgramSelectionPageState extends State<CyclingProgramSelectionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cycling Program Selection'),
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
                    builder: (context) => CustomCyclingProgramPage(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow,
                minimumSize: Size(200, 50),
              ),
              child: Text('Custom Program'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PlannedCyclingProgramsPage(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow,
                minimumSize: Size(200, 50),
              ),
              child: Text('Planned Programs'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MyPersonalTrainerPlanCyclingPage(), // Navigate to "My Personal Trainer Plan"
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow,
                minimumSize: Size(200, 50),
              ),
              child: Text('My Personal Trainer Plan'),
            ),
          ],
        ),
      ),
    );
  }
}
