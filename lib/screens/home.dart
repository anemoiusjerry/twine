import 'package:flutter/material.dart';
import 'package:twine/widgets/countdown_donut.dart';
import 'package:flutter_analog_clock/flutter_analog_clock.dart';
import 'package:twine/widgets/love_counter.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.black, width: 4)
              ),
              child: ClipOval(
                child: Image.network('https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg')
              )
            ),
            
            const Flexible(
              child: Text('Jovana Jastrebic', 
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18))
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly, 
          children: [
            CountdownDonut(
              reunionDate: DateTime(2025, 3, 1),
              separationDate: DateTime(2024, 11, 17)
            ),
            const SizedBox(width: 115, child: AnalogClock(markingWidthFactor: 0, hourNumberRadiusFactor: 0.9,))
          ],
        ),
        LoveCounter(anniversaryDate: DateTime(2023, 11, 4),)
      ],
    ));
  }
}
