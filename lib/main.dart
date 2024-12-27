import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:twine/firebase_options.dart';
import 'package:twine/screens/login/index.dart';
import 'package:twine/styles/colours.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, 
  );
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
        colorScheme: const ColorScheme(
          brightness: Brightness.light, 
          primary: AppColours.primary, 
          onPrimary: Colors.white, 
          secondary: AppColours.secondary, 
          onSecondary: Colors.white, 
          error: Colors.red, 
          onError: Colors.white, 
          surface: Colors.white, 
          onSurface: Colors.black
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          shape: CircleBorder(),
          backgroundColor: AppColours.secondary, 
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(width: 0)
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(width: 0)
          ),
          errorStyle: const TextStyle(
            color: Colors.white,
            fontSize: 15
          ),
          hintStyle: const TextStyle(color: AppColours.gray)
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Colors.white, width: 2)
          )
        ),
        useMaterial3: true,
      ),
      home: const LoginNavigator()
    );
  }
}