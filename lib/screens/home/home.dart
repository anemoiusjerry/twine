import 'package:flutter/material.dart';
import 'package:twine/widgets/countdown_donut.dart';
import 'package:twine/widgets/timezone_clock.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: 175,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(width: 5, color: colorScheme.primary)
                  ),
                  child: ClipOval(
                    child: Image.network('https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg')
                  )
                ),
                
                const Flexible(
                  child: Text('Jovana Jastrebic', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20))
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
                const SizedBox(
                  width: 140, 
                  child: TimezoneClock()
                )
              ],
            ),
            //CountdownDonut(anniversaryDate: DateTime(2023, 11, 4),)
          ],
        )
      );
  }
}