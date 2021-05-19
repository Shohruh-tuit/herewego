import 'package:flutter/material.dart';
import 'package:herewego/pages/signin_page.dart';

class HomePage extends StatefulWidget {
  static final String id = "home_page";

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: FlatButton(
        color: Colors.red,
        onPressed: () {
          Navigator.pushReplacementNamed(context, SignInPage.id);
        },
        child: Text(
          "Log Out",
          style: TextStyle(color: Colors.white),
        ),
      ),
    ));
  }
}
