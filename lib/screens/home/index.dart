import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:twine/screens/audio_log.dart';
import 'package:twine/screens/home/home.dart';
import 'package:twine/screens/setup/index.dart';

class HomeNavigator extends StatefulWidget {
  const HomeNavigator({super.key});
  @override
  State<HomeNavigator> createState() => _HomeNavigatorState();
}

class _HomeNavigatorState extends State<HomeNavigator> {
  int screenIndex = 1;
  final Stream<DocumentSnapshot<Map<String, dynamic>>> _userStream = 
  FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).snapshots();

  void _updateScreenIndex(int newIndex) {
    // setSet informs flutter of change causing the "build" method below to rerun.
    setState(() { screenIndex = newIndex; });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return StreamBuilder(
      stream: _userStream, 
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.white,)
          );
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data!.data() == null) {
          return const Center(child: Text('No user data found'));
        }

        // monitor the coupleId field
        final String? coupleId = snapshot.data!.data()?['coupleId'];
        if (coupleId == null) {
          return const SetupNavigator();
        } else {
          return Scaffold(
            appBar: AppBar(
              actions: [
                IconButton(
                  iconSize: 45,
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                  }, 
                  icon: const Icon(Icons.person_outline_rounded)
                ),
              ],
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: screenIndex,
              onTap: _updateScreenIndex,
              showSelectedLabels: false,
              showUnselectedLabels: false,
              iconSize: 45,
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.photo_library), 
                  label: "Cards",
                ),          
                BottomNavigationBarItem(
                  icon: Icon(Icons.home_rounded), 
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.album_outlined), 
                  label: 'Memos',
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
    );
  }
}