import 'package:flutter/material.dart';
import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';

class CountdownTimer extends StatelessWidget {
  const CountdownTimer({super.key, required this.endTime});
  final DateTime endTime;

  @override
  Widget build(BuildContext context) {
    final colourScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(left: 15, top: 15, bottom: 15, right: 5),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          TimerCountdown(
            endTime: endTime, 
            timeTextStyle: const TextStyle(fontSize: 20),
          ),
          const SizedBox(width: 5,),
          IconButton(
            onPressed: () => showDateTimePicker(context), 
            icon: const Icon(Icons.edit),
            color: colourScheme.primary,
          )
        ],
      )
    );
  }
}

void showDateTimePicker(BuildContext context) async {
  final currentDate = DateTime.now();
  final int maxYear = currentDate.year + 10;

  DateTime? datePicked = await showDialog<DateTime>(
    context: context, 
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: CalendarDatePicker(
            initialDate: DateTime.now(),
            firstDate: currentDate, 
            lastDate: DateTime(maxYear),
            onDateChanged: (DateTime value) {
              Navigator.of(context).pop(); // Return the picked date
            },
          )
        ),
      );
    }
  );
  if (context.mounted) {
    // exit out of the popover
    Navigator.of(context).pop();
  }
}