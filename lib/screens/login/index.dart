import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:twine/screens/home/index.dart';
import 'package:twine/screens/login/login_page.dart';
import 'package:twine/screens/login/sign_up_page.dart';

class LoginNavigator extends StatefulWidget {
  const LoginNavigator({super.key});

  @override
  State<LoginNavigator> createState() => _LoginNavigatorState();
}

class _LoginNavigatorState extends State<LoginNavigator> {
  final pageController = PageController();

  void navToPage(int index) {
    pageController.animateToPage(
      index, 
      duration: const Duration(milliseconds: 300), 
      curve: Curves.easeInOut
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          User? user = snapshot.data;
          // Main stack vs login stack transition
          if (user != null) {
            return const HomeNavigator();
          }
          else {
            return Scaffold(
              body: PageView(
                controller: pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  LoginPage(flipPage: navToPage,),
                  SignUpPage(onBackPress: () => navToPage(0),),
                ],
              ),
            );
          }
        }
        return Container(
          color: theme.primary, 
          child: const Center(
            child: CircularProgressIndicator(color: Colors.white,)
          )
        );
      }
    );
  }
}