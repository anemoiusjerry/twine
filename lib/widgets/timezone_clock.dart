import 'package:flutter/material.dart';
import 'package:flutter_analog_clock/flutter_analog_clock.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class TimezoneClock extends StatefulWidget {
  const TimezoneClock({super.key, this.tzString});
  final String? tzString;

  @override
  State<TimezoneClock> createState() => _TimezoneClockState();
}

class _TimezoneClockState extends State<TimezoneClock> {
  late tz.Location partnerTz;

  @override
  void initState() {
    super.initState();
    tz.initializeTimeZones();
    // tz.local here is UTC
    partnerTz = widget.tzString != null ? tz.getLocation(widget.tzString!) : tz.local;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
  
    return GestureDetector(
      onTap: () {
        _showTimezones(context);
      },
      child: 
      
      AnalogClock(
        dateTime: tz.TZDateTime.now(partnerTz),
        markingWidthFactor: 0, 
        hourNumberRadiusFactor: 0.9,
        dialBorderWidthFactor: 0.05,
        dialBorderColor: colorScheme.secondary,
        secondHandColor: Colors.red,
        child: Align(
          alignment: const FractionalOffset(0.5, 0.75),
          child: Text(tz.TZDateTime.now(partnerTz).hour < 12 ? "AM" : "PM")
        ),
      )
    );
  }

  void _showTimezones(BuildContext context) {
    tz.initializeTimeZones();
    final timezones = tz.timeZoneDatabase.locations;
    showDialog(
      context: context, 
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Select your partner's timezone"),
          content: SizedBox(
            height: 300,
            width: 300,
            child: ListView.builder(
            shrinkWrap: true,
            itemCount: timezones.length,
            itemBuilder: (_, int index) {
              return ListTile(
                title: Text(timezones.keys.elementAt(index)),
                onTap: () {
                  Navigator.pop(context);
                },
              );
            },
          )),
        );
      }
    );
  }
}