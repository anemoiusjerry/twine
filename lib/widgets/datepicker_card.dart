import 'package:flutter/material.dart';

class DatepickerCard extends StatelessWidget {
  DatepickerCard({super.key, required this.handleDateSelect}):
  firstDate = DateTime(DateTime.now().year - 5),
  lastDate = DateTime(DateTime.now().year + 5);

  final DateTime firstDate;
  final DateTime lastDate;
  final Function(DateTime) handleDateSelect;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: CalendarDatePicker(
        initialDate: DateTime.now(),
        firstDate: firstDate, 
        lastDate: lastDate,
        onDateChanged: (DateTime date) {
          handleDateSelect(date);
          Navigator.of(context).pop();
        },
      )
    );
  }
}