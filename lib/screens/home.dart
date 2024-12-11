import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Column(
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ClipOval(
                child: Image.network(
              'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg',
              width: 150,
            )),
            const SizedBox(
              width: 10,
            ),
            const Text('Jovana Jastrebic',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          ],
        )
      ],
    ));
  }
}
