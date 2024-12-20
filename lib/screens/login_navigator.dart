import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:twine/screens/home_navigator.dart';
import 'package:twine/screens/login/login_page.dart';
import 'package:twine/screens/login/sign_up_page.dart';

class LoginNavigator extends StatelessWidget {
  const LoginNavigator({super.key});

  bool _checkValidEmail(String? emailAddress) {
    const pattern = r"(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'"
    r'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-'
    r'\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*'
    r'[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4]'
    r'[0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9]'
    r'[0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\'
    r'x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])';
    final regex = RegExp(pattern);
    //print(regex.hasMatch(emailAddress!));
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

  // check user session


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final pageController = PageController();

    void navToPage(int index) {
      pageController.animateToPage(
        index, 
        duration: const Duration(milliseconds: 300), 
        curve: Curves.easeInOut
      );
    }

    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          User? user = snapshot.data;
          if (user != null) {
            return const HomeNavigator();
          }
          else {
            return Scaffold(
              backgroundColor: theme.primary,
              body: PageView(
                controller: pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  LoginPage(
                    onSignUpPress: () => navToPage(1), 
                    checkValidEmail: _checkValidEmail,
                    showSnackBar: _showErrorSnackBar,
                  ),
                  SignUpPage(
                    onBackPress: () => navToPage(0), 
                    checkValidEmail:  _checkValidEmail,
                    showSnackBar: _showErrorSnackBar,
                  )
                ],
              ),
            );
          }
        }
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      }
    );
  }
}