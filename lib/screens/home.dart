import 'package:chat_app/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/custom_user.dart';
import '../services/auth.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {

    final userUIDData = Provider.of<UserUID?>(context);

    return StreamProvider<CustomUser?>.value(
      value: DatabaseService(uid: userUIDData!.uid).userDataStream,
      initialData: null,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Home',
          ),
          //a list of widgets to display in a row after the title widget
          actions: [
            //logout button
            TextButton.icon(
              icon: const Icon(Icons.person),
              onPressed: () async {
                await _auth.signOut();
              },
              label: const Text(
                'Logout',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
