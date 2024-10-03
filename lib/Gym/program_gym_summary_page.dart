import 'package:flutter/material.dart';

class ProgramGymSummaryPage extends StatefulWidget {
  final List<Map<String, dynamic>> exercises;

  const ProgramGymSummaryPage({super.key, required this.exercises});

  @override
  _ProgramGymSummaryPageState createState() => _ProgramGymSummaryPageState();
}

class _ProgramGymSummaryPageState extends State<ProgramGymSummaryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Program Summary'),
        backgroundColor: const Color.fromARGB(255, 40, 39, 41),
      ),
      backgroundColor: const Color.fromARGB(255, 40, 39, 41),
      body: ListView.builder(
        itemCount: widget.exercises.length,
        itemBuilder: (context, index) {
          final exercise = widget.exercises[index];
          return ListTile(
            title: Text(exercise['exercise'], style: const TextStyle(color: Color(0xFFF7BB0E))),
            subtitle: Row(
              children: [
                Expanded(
                  child: TextField(
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Reps'),
                    onChanged: (value) {
                      setState(() {
                        exercise['reps'] = int.tryParse(value) ?? 0;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Weight (kg)'),
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
              icon: const Icon(Icons.delete, color: Colors.red),
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
