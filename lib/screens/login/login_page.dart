import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:twine/screens/home_navigator.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({
    super.key, 
    required this.onSignUpPress,
    required this.checkValidEmail,
    required this.showSnackBar,
  });

  final VoidCallback onSignUpPress;
  final bool Function(String?) checkValidEmail;
  final void Function(BuildContext, String) showSnackBar;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String email = "";
  String password = "";
  final _formKey = GlobalKey<FormState>();
  
  void checkLoginStatus() {
    
  }

  _handleLogin() async {
    try {
      if (_formKey.currentState!.validate()) {
        final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email.trim(),
          password: password.trim(),
        );
        // login success go to home page
        Navigator.of(context, rootNavigator: true).push(
          MaterialPageRoute(
            builder: (_) => const HomeNavigator()
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      // ONLY will receive 'INVALID_LOGIN_CREDENTIALS' due to email enumeration
      print(e);
      if (e.code == 'user-not-found') {
        widget.showSnackBar(context, "No user found for that email.");
      } else if (e.code == 'wrong-password') {
        widget.showSnackBar(context, "Wrong password provided for that user.");
      } else {
        widget.showSnackBar(context, e.message ?? "Unknown error has ocurred.");
      }
    } catch (e) {
      print(e);
      widget.showSnackBar(context, "An error has occurred, please try again later.");
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40), 
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  prefixIcon: Icon(Icons.person, color: theme.primary,),
                  hintText: "Email Address",
                ),
                onChanged: (text) {
                  setState(() {email = text;});
                },
                validator: (text) {
                  return widget.checkValidEmail(text) ? null : 'Invalid Email';
                },
              ),
              const SizedBox(height: 10,),
              TextField(
                obscureText: true,
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
      ),
    );
  }
}