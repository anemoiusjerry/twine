import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:twine/models/user_model.dart' show TwineUser;
import 'package:twine/repositories/user_interface.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({
    super.key, 
    required this.flipPage,
    required this.checkValidEmail,
    required this.showSnackBar,
  });

  final void Function(int) flipPage;
  final bool Function(String?) checkValidEmail;
  final void Function(BuildContext, String) showSnackBar;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String email = "";
  String password = "";
  final _formKey = GlobalKey<FormState>();

  _handleLogin(BuildContext context) async {
    try {
      if (_formKey.currentState!.validate()) {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email.trim(),
          password: password.trim(),
        );
      }
    } on FirebaseAuthException catch (e) {
      // ONLY will receive 'INVALID_LOGIN_CREDENTIALS' due to email enumeration
      if (context.mounted) {
        widget.showSnackBar(context, e.message ?? "Unknown error has ocurred.");
      }
    } catch (e) {
      print(e);
      if (context.mounted) {
        widget.showSnackBar(context, "An error has occurred, please try again later.");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return Container(color: theme.primary, child: Center(
      child: Padding(
        padding: const EdgeInsets.all(40), 
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.person, color: theme.secondary,),
                  hintText: "Email Address",
                ),
                onChanged: (text) {
                  setState(() {email = text;});
                },
                validator: (text) {
                  return widget.checkValidEmail(text) ? null : 'Invalid Email';
                },
              ),
              const SizedBox(height: 20,),
              TextFormField(
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.lock, color: theme.secondary,),
                  hintText: "Password",
                ),
                obscureText: true,
                onChanged: (text) {
                  setState(() {password = text;});
                },
              ),
              const SizedBox(height: 30,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OutlinedButton(
                    onPressed: () => _handleLogin(context), 
                    child: const Text("Log In", style: TextStyle(color: Colors.white, fontSize: 20),)
                  ),
                  const SizedBox(width: 10,),
                  OutlinedButton(
                    onPressed: () => widget.flipPage(1), 
                    child: const Text("Sign Up", style: TextStyle(color: Colors.white, fontSize: 20),)
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    ));
  }
}