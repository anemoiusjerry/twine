import 'package:flutter/material.dart';
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
      bottomNavigationBar: NavigationBar(
        indicatorColor: Colors.amber,
        selectedIndex: screenIndex,
        onDestinationSelected: _updateScreenIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.local_post_office),
            icon: Icon(Icons.local_post_office_outlined), 
            label: "Post Cards",
          ),          
          NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined), 
            label: 'Home',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.mic),
            icon: Icon(Icons.mic_outlined), 
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
        HomeScreen(),
        Card(
          shadowColor: Colors.transparent,
          margin: const EdgeInsets.all(8.0),
          child: SizedBox.expand(
            child: Center(
              child: Text(
                'Voice messages',
                style: theme.textTheme.titleLarge,
              ),
            ),
          ),
        ),
      ][screenIndex],
    );
  }
}
