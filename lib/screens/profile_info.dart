import 'dart:io';
import 'package:flutter/material.dart';

class ProfileInfoScreen extends StatelessWidget {
  final File? image;

  const ProfileInfoScreen(this.image, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[900],
      appBar: AppBar(
        title: const Text('Profile',style: TextStyle(color: Colors.amber),),
        centerTitle: true,
        backgroundColor: Colors.blueGrey[900],
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(30.0, 40.0, 30.0, 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                backgroundImage: image != null ? FileImage(image!) : null,
                radius: 60.0,
              ),
            ),
            const Divider(
              height: 50.0,
              color: Colors.white70,
            ),
            const Text(
              'NAME',
              style: TextStyle(
                color: Colors.white70,
                letterSpacing: 2.0,
              ),
            ),
            const SizedBox(height: 10.0,),
            const Text(
              'Name',
              style: TextStyle(
                color: Colors.amber,
                letterSpacing: 2.0,
                fontSize: 26.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30.0,),
            const Text(
              'DEGREE',
              style: TextStyle(
                color: Colors.white70,
                letterSpacing: 2.0,
              ),
            ),
            const SizedBox(height: 10.0,),
            const Text(
              'B-TECH',
              style: TextStyle(
                color: Colors.amber,
                letterSpacing: 2.0,
                fontSize: 26.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30.0,),
            const Row(
              children: [
                Icon(
                  Icons.phone,
                  color: Colors.white70,
                ),
                SizedBox(width: 10.0,),
                Text(
                  'Phone',
                  style: TextStyle(
                    color: Colors.amber,
                    fontSize: 15.0,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10.0,),
            const Row(
              children: [
                Icon(
                  Icons.email,
                  color: Colors.white70,
                ),
                SizedBox(width: 10.0,),
                Text(
                  'email id',
                  style: TextStyle(
                    color: Colors.amber,
                    fontSize: 15.0,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
