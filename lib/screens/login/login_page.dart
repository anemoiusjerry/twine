import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({
    super.key, 
    required this.onSignUpPress,
    required this.checkValidEmail
  });

  final VoidCallback onSignUpPress;
  final bool Function(String?) checkValidEmail;
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String email = "";
  String password = "";
  
  _handleLogin() async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email, 
        password: password
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40), 
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                prefixIcon: const Icon(Icons.person),
                hintText: "Email Address",
              ),
              onChanged: (text) {
                setState(() {email = text;});
              },
              validator: (text) {
                widget.checkValidEmail(text) ? null : 'Invalid Email';
              },
            ),
            const SizedBox(height: 10,),
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                prefixIcon: const Icon(Icons.lock),
                hintText: "Password",
              ),
              onChanged: (text) {
                setState(() {password = text;});
              },
            ),
            const SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton(
                  onPressed: _handleLogin, 
                  child: const Text("Log In")
                ),
                const SizedBox(width: 10,),
                OutlinedButton(
                  onPressed: widget.onSignUpPress, 
                  child: const Text("Sign Up")
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}