import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:herewego/pages/home_page.dart';
import 'package:herewego/pages/signin_page.dart';
import 'package:herewego/services/auth_service.dart';
import 'package:herewego/services/prefs_service.dart';
import 'package:herewego/services/utils_service.dart';

class SignUpPage extends StatefulWidget {
  static final String id = "signup_page";

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  var isLoading = false;

  var fullNameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  _doSignUp() {
    String name = fullNameController.text.toString().trim();
    String email = emailController.text.toString().trim();
    String password = passwordController.text.toString().trim();

    if (name.isEmpty || email.isEmpty || password.isEmpty) return;

    setState(() {
      isLoading = true;
    });

    AuthService.signUpUser(context, name, email, password)
        .then((firebaseUser) => {
              _getFirebaseUser(firebaseUser),
            });
  }

  _getFirebaseUser(FirebaseUser firebaseUser) async {
    setState(() {
      isLoading = false;
    });
    if (firebaseUser != null) {
      await Prefs.saveUserId(firebaseUser.uid);
      Navigator.pushReplacementNamed(context, HomePage.id);
    } else {
      Utils.fireToast("Informatsiyalaringizni tekshiring");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: fullNameController,
                  decoration: InputDecoration(hintText: "Full Name"),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(hintText: "Email"),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: passwordController,
                  decoration: InputDecoration(hintText: "Password"),
                ),
                SizedBox(height: 10),
                FlatButton(
                  color: Colors.red,
                  onPressed: _doSignUp,
                  child: Text(
                    "Sign Up",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                FlatButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, SignInPage.id);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        "Already have an accout?",
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(width: 10),
                      Text(
                        "Sign In",
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : SizedBox.shrink(),
        ],
      ),
    );
  }
}
