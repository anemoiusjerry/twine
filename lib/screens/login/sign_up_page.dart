// Sign up page
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_pw_validator/flutter_pw_validator.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({
    super.key, 
    required this.onBackPress, 
    required this.checkValidEmail,
    required this.showSnackBar,
  });

  final VoidCallback onBackPress;
  final bool Function(String?) checkValidEmail;
  final void Function(BuildContext, String) showSnackBar;

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  String email = "";
  String password = "";
  String confirmPassword = "";
  bool pwdValid = false;
  bool isSubmitting = false;
  bool createSuccess = false;
  StreamSubscription<DocumentSnapshot>? _subscription;

  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _emailController.addListener(setEmailAddress);
    _passwordController.addListener((setPassword));
  }

  @override
  void dispose() {
    // clean up controller when widget is removed from tree
    _emailController.dispose();
    _passwordController.dispose();
    _subscription?.cancel();
    super.dispose();
  }

  void setEmailAddress() {
    setState(() {
      email = _emailController.text;
    });
  }
  void setPassword() {
    setState(() {
      password = _passwordController.text;
    });
  }

  Future<void> _createAccount(BuildContext context) async {
    if (_formKey.currentState!.validate() && pwdValid) {
      try {
        // user create request
        UserCredential cred = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email.trim(), password: password.trim()); 
        String userId = cred.user?.uid ?? "";

        // set up listener
        _subscription = FirebaseFirestore.instance
          .collection("users")
          .doc(userId)
          .snapshots()
          .listen((DocumentSnapshot snap) {
            if (snap.exists) {
              // cancel listener
              _subscription?.cancel();
            }
          });
      } catch(e) {
        print(e);
        if (context.mounted) {
          widget.showSnackBar(context, "An error has occurred, please try again later.");
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return Scaffold(
      // Back nav button on top bar
      appBar: isSubmitting ? null : AppBar(
        // this bar is hidden if API calls are made
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: widget.onBackPress,
          color: Colors.white,
        ),
        backgroundColor: theme.primary,
      ),
      backgroundColor: theme.primary,
      // page content
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(40), 
          child: isSubmitting ?
            // loading circle on submission
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [ 
                  createSuccess ? const Icon(Icons.check_circle, size: 60, color: Colors.green,) : const CircularProgressIndicator(color: Colors.white,),
                  const SizedBox(height: 20,),
                  Text(createSuccess ? "Account created!" : "Creating your account...", style: const TextStyle(fontSize: 18, color: Colors.white),),
                ],
              ),
            ) :
            // Input fields for account creation
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.person),
                    hintText: "Email Address",
                  ),
                  validator: (text) {
                    return widget.checkValidEmail(text) ? null : 'Please enter a valid email address';
                  },
                ),
                const SizedBox(height: 10,),

                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.lock_open),
                    hintText: "Password",
                  ),
                  validator: (text) {
                    return pwdValid ? null : "Please fulfill the password requirements";
                  },
                ),
                const SizedBox(height: 10,),

                TextFormField(
                  obscureText: true,
                  autocorrect: false,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.lock),
                    hintText: "Confirm Password",
                  ),
                  validator: (text) {
                    return text == password ? null : "Passwords do not match";
                  },
                ),
                const SizedBox(height: 20,),
                
                FlutterPwValidator(
                  width: 350, 
                  height: 150, 
                  minLength: 8,
                  uppercaseCharCount: 1,
                  lowercaseCharCount: 1,
                  numericCharCount: 1,
                  specialCharCount: 1,
                  onSuccess: () { 
                    setState(() { pwdValid = true; });
                  },
                  onFail: () {
                    setState(() { pwdValid = false; });
                  },
                  controller: _passwordController
                ),
                const SizedBox(height: 10,),

                OutlinedButton(
                  style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.white, width: 2)),
                  onPressed: () => _createAccount(context), 
                  child: const Text("Sign Up", style: TextStyle(color: Colors.white, fontSize: 20),)
                ),
              ],
            ),
        ),
      ),
    );
  }
}