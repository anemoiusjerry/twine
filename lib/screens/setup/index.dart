import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:twine/models/user_model.dart';
import 'package:twine/screens/setup/connect_page.dart';
import 'package:twine/screens/setup/setup_page.dart';

class SetupNavigator extends StatefulWidget {
  const SetupNavigator({super.key, required this.reload});

  final VoidCallback reload;
  @override
  State<SetupNavigator> createState() => _SetupNavigatorState();
}

class _SetupNavigatorState extends State<SetupNavigator> {
  // setup stream to monitor current user doc in Firestore
  final Stream<DocumentSnapshot<Map<String, dynamic>>> _userStream = 
    FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).snapshots();
  final _pageController = PageController();

  String connectCode = "Gen. code";
  String storagePath = "";

  void navToPage(int index) {
    _pageController.animateToPage(
      index, 
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.primary,
        leading: IconButton(
          iconSize: 45,
          onPressed: () async {
            await FirebaseAuth.instance.signOut();
          }, 
          icon: const Icon(Icons.logout, color: Colors.white,)
        ),
      ),
      body: StreamBuilder(
        stream: _userStream, 
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            TwineUser user = TwineUser.fromFirestore(snapshot.data!, null);
            // NO CODE means something went wrong during user creation
            connectCode = user.connectCode ?? "NO CODE";
            storagePath = "${user.coupleId}/${FirebaseAuth.instance.currentUser!.uid}/profile.jpeg";
            // coupleId indicates couple entry exists => move to home page setup
            if (user.coupleId != null) {
              navToPage(1);
            }
          }

          return PageView(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: <Widget> [
              ConnectPage(
                connectCode: connectCode,
                onSubmit: () => navToPage(1)
              ),
              SetupPage(reload: widget.reload, storagePath: storagePath,),
            ],
          );
        }
      )
    );
  }
}