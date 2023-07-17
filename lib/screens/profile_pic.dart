
// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'dart:io';
import 'package:chat_app/screens/profile_info.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';



class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  File? _image;
  final picker = ImagePicker();

  Future<void> saveAndNavigate() async {
    await uploadImage();

    // Navigate to the profile information screen
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ProfileInfoScreen()),
    );
  }

  Future getImage() async {
  final pickedFile = await picker.pickImage(source: ImageSource.gallery);

  setState(() {
    if (pickedFile != null) {
      _image = File(pickedFile.path);
    } else {
      print('No image selected.');
    }
  });
}

  Future uploadImage() async {
  if (_image == null) {
    print('No image selected.');
    return;
  }

  String fileName = DateTime.now().toString();
  Reference reference = FirebaseStorage.instance.ref().child(fileName);
  UploadTask uploadTask = reference.putFile(_image!);
  TaskSnapshot storageTaskSnapshot = await uploadTask.whenComplete(() {});
  String imageUrl = await storageTaskSnapshot.ref.getDownloadURL();

  // Perform actions with the uploaded image URL
  print('Image URL: $imageUrl');
}

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Profile',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Profile'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircleAvatar(
                radius: 80,
                backgroundColor: Colors.grey,
                backgroundImage: _image != null ? FileImage(_image!) : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: getImage,
                child: const Text('Select Image'),
              ),
              ElevatedButton(
                onPressed: saveAndNavigate,
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}