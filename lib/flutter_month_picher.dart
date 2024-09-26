import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import for DateFormat

class MonthPickerDialog extends StatefulWidget {
  final DateTime selectedDate;
  final ValueChanged<DateTime> onChanged;

  const MonthPickerDialog({
    super.key,
    required this.selectedDate,
    required this.onChanged,
  });

  @override
  _MonthPickerDialogState createState() => _MonthPickerDialogState();
}

class _MonthPickerDialogState extends State<MonthPickerDialog> {
  late int _selectedMonth;
  late int _selectedYear;

  @override
  void initState() {
    super.initState();
    _selectedMonth = widget.selectedDate.month;
    _selectedYear = widget.selectedDate.year;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select Month'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Month Dropdown
          DropdownButton<int>(
            value: _selectedMonth,
            items: List.generate(12, (index) {
              return DropdownMenuItem<int>(
                value: index + 1,
                child: Text(DateFormat('MMMM').format(DateTime(_selectedYear, index + 1))),
              );
            }),
            onChanged: (month) {
              if (month != null) {
                setState(() {
                  _selectedMonth = month;
                });
              }
            },
          ),
          // Year Dropdown
          DropdownButton<int>(
            value: _selectedYear,
            items: List.generate(10, (index) {
              int year = DateTime.now().year - 5 + index; // Show current year and 5 years prior
              return DropdownMenuItem<int>(
                value: year,
                child: Text('$year'),
              );
            }),
            onChanged: (year) {
              if (year != null) {
                setState(() {
                  _selectedYear = year;
                });
              }
            },
          ),
        ],
      ),
      actions: [
       Container(
  decoration: BoxDecoration(
    color: Color(0xFFF7BB0E), // Set your desired background color
    borderRadius: BorderRadius.circular(8.0), // Optional: for rounded corners
  ),
  child: TextButton(
    onPressed: () {
      // Notify parent widget of the new selected month and year
      widget.onChanged(DateTime(_selectedYear, _selectedMonth));
      Navigator.of(context).pop(); // Close the dialog
    },
    child: const Text(
      'OK',
      style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)), // Set text color for visibility
    ),
  ),
),

        Container(
                 decoration: BoxDecoration(
                  color: Color(0xFFF7BB0E), // Set your desired background color
                   borderRadius: BorderRadius.circular(8.0), // Optional: for rounded corners
                     ),
                     child: TextButton(
                     onPressed: () {
                     Navigator.of(context).pop(); // Close the dialog
                     },
          child: const Text(
          'Cancel',
           style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)), // Set text color for visibility
          ),
         ),
        )
      ],
    );
  }
}
