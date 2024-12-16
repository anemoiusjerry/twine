// Sign up page
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

  _createAccount () async {
    // try logging in if email is valid, passwords match
    if (_formKey.currentState!.validate() && pwdValid) {
      try {
        _formKey.currentState!.save();
        setState(() {
          isSubmitting = true;
        });

        final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email.trim(),
          password: password.trim(),
        );

        setState(() {
          createSuccess = true;
          // clear data
          email = "";
          password = "";
        });

        // delay time to show success screen
        Future.delayed(const Duration(seconds: 2), () {
          setState(() {
            createSuccess = false;
            isSubmitting = false;
          });
          widget.onBackPress();
        });
      } on FirebaseAuthException catch (e) {
        setState(() {
          isSubmitting = false;
        });
        // weak password == password requirements not met
        if (e.code == 'weak-password') {
          widget.showSnackBar(context, "The password provided is too weak.");
        } else if (e.code == 'email-already-in-use') {
          widget.showSnackBar(context, "An account already exists for that email.");
        } else {
          widget.showSnackBar(context, e.message ?? "Unknown error has ocurred.");
        }
      } catch (e) {
        setState(() {
          isSubmitting = false;
        });

        print(e);
        widget.showSnackBar(context, "An error has occurred, please try again later.");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Back nav button on top bar
      appBar: isSubmitting ? null : AppBar(
        // this bar is hidden if API calls are made
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: widget.onBackPress,
        ),
      ),

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
                  createSuccess ? const Icon(Icons.check_circle, size: 60, color: Colors.green,) : const CircularProgressIndicator(),
                  const SizedBox(height: 20,),
                  Text(createSuccess ? "Account created!" : "Creating your account...", style: const TextStyle(fontSize: 18),),
                ],
              ),
            ) :
            // Input fields for account creation
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    prefixIcon: const Icon(Icons.person),
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
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    prefixIcon: const Icon(Icons.lock_open),
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
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    prefixIcon: const Icon(Icons.lock),
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
                  onPressed: _createAccount, 
                  child: const Text("Sign Up")
                ),
              ],
            ),
        ),
      ),
    );
  }
}