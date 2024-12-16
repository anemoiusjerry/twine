import 'package:flutter/material.dart';
import 'package:twine/screens/audio_log.dart';
import 'package:twine/screens/home.dart';

class HomeNavigator extends StatefulWidget {
  const HomeNavigator({super.key});
  @override
  State<HomeNavigator> createState() => _HomeNavigatorState();
}

class _HomeNavigatorState extends State<HomeNavigator> {
  int screenIndex = 1;

  void _updateScreenIndex(int newIndex) {
    // setSet informs flutter of change causing the "build" method below to rerun.
    setState(() { screenIndex = newIndex; });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: screenIndex,
        selectedItemColor: Colors.amber,
        onTap: _updateScreenIndex,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.local_post_office), 
            label: "Post Cards",
          ),          
          BottomNavigationBarItem(
            icon: Icon(Icons.home), 
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.album), 
            label: 'Voice Messages',
          ),
        ]
      ),

      // Actual screens for the tabs
      body: <Widget>[
        Card(
          shadowColor: Colors.transparent,
          margin: const EdgeInsets.all(8.0),
          child: SizedBox.expand(
            child: Center(
              child: Text(
                'home',
                style: theme.textTheme.titleLarge,
              ),
            ),
          ),
        ),
        const HomeScreen(),
        const AudioLogScreen(),
      ][screenIndex],
    );
  }
}
