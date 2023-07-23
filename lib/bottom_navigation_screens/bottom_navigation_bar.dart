import 'package:chat_app/bottom_navigation_screens/profile_page.dart';
import 'package:chat_app/bottom_navigation_screens/home.dart';
import 'package:chat_app/bottom_navigation_screens/settings.dart';
import 'package:chat_app/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/custom_user.dart';

class BottomNavigation extends StatefulWidget {

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {

    final userUIDData = Provider.of<UserUID?>(context);

    final tabs = [Home(), SettingsScreen(), Profile()];

    return StreamProvider<CustomUser?>.value(
      value: DatabaseService(uid: userUIDData!.uid).userDataStream,
      initialData: null,
      catchError: (_,__) {
        return null;
      },
      child: Scaffold(
        body: tabs[currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentIndex,
          type: BottomNavigationBarType.shifting,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
              backgroundColor: Colors.blue,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
              backgroundColor: Colors.blue,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
              backgroundColor: Colors.blue,
            ),
          ],
          onTap: (index) {
            setState(() {
              currentIndex = index;
            });
          },
        ),
      ),
    );
  }
}
