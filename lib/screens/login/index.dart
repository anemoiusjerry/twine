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

  bool _checkValidEmail(String? emailAddress) {
    const pattern = r"(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'"
    r'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-'
    r'\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*'
    r'[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4]'
    r'[0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9]'
    r'[0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\'
    r'x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])';
    final regex = RegExp(pattern);
    return emailAddress!.isNotEmpty && regex.hasMatch(emailAddress);
  }

  void _showErrorSnackBar(BuildContext context, String errorText) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(errorText),
        duration: const Duration(seconds: 3),
      ),
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
                  LoginPage(
                    flipPage: navToPage, 
                    checkValidEmail: _checkValidEmail,
                    showSnackBar: _showErrorSnackBar,
                  ),
                  SignUpPage(
                    onBackPress: () => navToPage(0), 
                    checkValidEmail:  _checkValidEmail,
                    showSnackBar: _showErrorSnackBar,
                  ),
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