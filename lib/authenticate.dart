import 'package:chat_app/screens/register.dart';
import 'package:chat_app/screens/sign_in.dart';
import 'package:flutter/material.dart';

class Authenticate extends StatefulWidget {
  const Authenticate({Key? key}) : super(key: key);

  @override
  State<Authenticate> createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  //here, we are supposed to return either the 'sign-in' screen or the 'register' screen depending on whether the user's account exists
  bool showSignIn = true; //if this is true, we show sign-in screen, else we show the register screen

  void toggleView() { //so that user can switch between Sign In screen and Register screen
    setState(() {
      showSignIn = !showSignIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showSignIn) {
      return SignIn(toggleView: toggleView); //passing toggleView function as parameter so that it can be accessed
    }
    else {
      return Register(toggleView: toggleView);
    }
  }
}
