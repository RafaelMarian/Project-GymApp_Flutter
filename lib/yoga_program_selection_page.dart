import 'package:flutter/material.dart';
import 'custom_yoga_program_page.dart';
import 'planned_yoga_programs_page.dart';
import 'my_personal_trainer_plan_yoga_page.dart'; // Import Personal Trainer Plan page

class YogaProgramSelectionPage extends StatefulWidget {
  @override
  _YogaProgramSelectionPageState createState() =>
      _YogaProgramSelectionPageState();
}

class _YogaProgramSelectionPageState extends State<YogaProgramSelectionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Yoga Program Selection'),
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
                    builder: (context) => PlannedYogaProgramsPage(),
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
                    builder: (context) => MyPersonalTrainerPlanYogaPage(), // Navigate to "My Personal Trainer Plan"
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
