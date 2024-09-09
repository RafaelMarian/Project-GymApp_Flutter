import 'package:flutter/material.dart';

class ProgramGymSummaryPage extends StatefulWidget {
  final List<Map<String, dynamic>> exercises;

  ProgramGymSummaryPage({required this.exercises});

  @override
  _ProgramGymSummaryPageState createState() => _ProgramGymSummaryPageState();
}

class _ProgramGymSummaryPageState extends State<ProgramGymSummaryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Program Summary'),
        backgroundColor: Colors.grey[800],
      ),
      backgroundColor: Colors.grey[800],
      body: ListView.builder(
        itemCount: widget.exercises.length,
        itemBuilder: (context, index) {
          final exercise = widget.exercises[index];
          return ListTile(
            title: Text(exercise['exercise'], style: TextStyle(color: Colors.yellow)),
            subtitle: Row(
              children: [
                Expanded(
                  child: TextField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: 'Reps'),
                    onChanged: (value) {
                      setState(() {
                        exercise['reps'] = int.tryParse(value) ?? 0;
                      });
                    },
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: 'Weight (kg)'),
                    onChanged: (value) {
                      setState(() {
                        exercise['weight'] = int.tryParse(value) ?? 0;
                      });
                    },
                  ),
                ),
              ],
            ),
            trailing: IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                setState(() {
                  widget.exercises.removeAt(index);
                });
              },
            ),
          );
        },
      ),
    );
  }
}
