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
          DropdownButton<int>(
            value: _selectedYear,
            items: List.generate(10, (index) {
              int year = DateTime.now().year - 5 + index;
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
        TextButton(
          onPressed: () {
            widget.onChanged(DateTime(_selectedYear, _selectedMonth));
            Navigator.of(context).pop();
          },
          child: const Text('OK'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}
