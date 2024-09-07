import 'package:flutter/material.dart';
import 'custom_cycling_program_page.dart';
import 'planned_cycling_programs_page.dart';

class CyclingProgramSelectionPage extends StatefulWidget {
  @override
  _CyclingProgramSelectionPageState createState() =>
      _CyclingProgramSelectionPageState();
}

class _CyclingProgramSelectionPageState
    extends State<CyclingProgramSelectionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cycling Program Selection'),
        backgroundColor: Colors.grey[800],
      ),
      backgroundColor: Colors.grey[800],
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Add your logo here
          Container(
            margin: EdgeInsets.symmetric(vertical: 20.0),
            child: Image.asset(
              'assets/cycling_logo.png', // Replace with your logo asset path
              height: 100.0, // Adjust the height as needed
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
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
                  child: Text('Custom'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellow,
                  ),
                ),
                SizedBox(width: 20), // Space between buttons
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PlannedCyclingProgramsPage(),
                      ),
                    );
                  },
                  child: Text('Planned Cycling Programs'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellow,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
