import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:herewego/pages/home_page.dart';
import 'package:herewego/pages/signup_page.dart';
import 'package:herewego/services/auth_service.dart';
import 'package:herewego/services/prefs_service.dart';
import 'package:herewego/services/utils_service.dart';

class SignInPage extends StatefulWidget {
  static final String id = "signin_page";
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  var isLoading = false;
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  _doSignIn() {
    String email = emailController.text.toString().trim();
    String password = passwordController.text.toString().trim();

    if (email.isEmpty || password.isEmpty) return;

    setState(() {
      isLoading = true;
    });

    AuthService.signInUser(context, email, password).then((firebaseUser) => {
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
      Utils.fireToast("Email va parolingizni tekshiring");
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
                  onPressed: _doSignIn,
                  child: Text(
                    "Sign in",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                FlatButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, SignUpPage.id);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        "Don't have an accout?",
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(width: 10),
                      Text(
                        "Sign Up",
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
