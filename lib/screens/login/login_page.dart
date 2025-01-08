import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:twine/helper.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.flipPage,});

  final void Function(int) flipPage;
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
        ScaffoldMessenger.of(context)
        .showSnackBar(generateSnackBar(e.message ?? "Unknown error has ocurred."));
      }
    } catch (e) {
      print(e);
      if (context.mounted) {
        ScaffoldMessenger.of(context)
        .showSnackBar(generateSnackBar("An error has occurred, please try again later."));
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
                  if (text == null || !checkValidEmail(text)) {
                    return 'Invalid Email';
                  }
                  return null;
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