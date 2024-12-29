import 'package:flutter/material.dart';

class DatepickerCard extends StatelessWidget {
  const DatepickerCard({
    super.key, 
    required this.initialDate, 
    required this.handleDateSelect,
    required this.firstDate,
    required this.lastDate,
  });

  final DateTime initialDate;
  final DateTime firstDate;
  final DateTime lastDate;
  final Function(DateTime) handleDateSelect;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: CalendarDatePicker(
        initialDate: initialDate,
        firstDate: firstDate, 
        lastDate: lastDate,
        onDateChanged: (DateTime date) {
          // only allow date select if day is changed
          if (date.day != initialDate.day) {
          handleDateSelect(date);
          Navigator.of(context).pop();
          }
        },
      )
    );
  }
}