import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:twine/screens/login_navigator.dart';


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
      home: FutureBuilder(
        future: Firebase.initializeApp(), 
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Error'));
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return const LoginNavigator();
          }
          // show loading icon while waiting
          return const Center(child: SizedBox(
            child: CircularProgressIndicator(),
          ),);
        }
      ),
    );
  }
}