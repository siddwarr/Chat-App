import 'package:chat_app/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'authenticate.dart';
import 'models/custom_user.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {

    final userUIDData = Provider.of<UserUID?>(context); //accessing the user data from the provider

    //the purpose of wrapper is to return either Home widget or Authenticate widget based on whether the user is logged in or not
    if (userUIDData == null) { //it means that no user is currently logged in
      return const Authenticate();
    }
    else {
      return const Home();
    }
  }
}
