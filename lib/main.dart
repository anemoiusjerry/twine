import 'package:flutter/material.dart';
import 'package:twine/home_navigator.dart';

void main() {
  runApp(const TwineApp());
}

class TwineApp extends StatelessWidget {
  const TwineApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Twine',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomeNavigator(),
    );
  }
}