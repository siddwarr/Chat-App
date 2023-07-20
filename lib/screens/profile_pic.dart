// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously
import 'dart:io';
import 'package:chat_app/bottom_navigation_screens/profile_page.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ProfilePic extends StatefulWidget {
  final File? image;

  const ProfilePic({super.key, this.image});
  @override
  _ProfilePicState createState() => _ProfilePicState();
}

class _ProfilePicState extends State<ProfilePic> {
  File? _image;
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _image = widget.image;
  }

  Future<void> saveAndNavigate() async {
    await uploadImage();

    // Navigate to the ProfilePic information screen
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Profile(_image)),
    );
  }

  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
      else {
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
      title: 'ProfilePic',
      home: Scaffold(
        appBar:AppBar(
          title: const Text('Profile Picture', style: TextStyle(color: Colors.white)),
          centerTitle: true,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircleAvatar(
                radius: 80,
                backgroundColor: Colors.grey,
                backgroundImage: _image != null
                    ? FileImage(_image!)
                    : const AssetImage('assets/avatar.png') as ImageProvider,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                // style: ElevatedButton.styleFrom(
                //   backgroundColor: Colors.blueGrey[800],
                // ),
                onPressed: getImage,
                child: const Text('Select Image',style: TextStyle(color: Colors.white)),
              ),
              ElevatedButton(
                // style: ElevatedButton.styleFrom(
                //   backgroundColor: Colors.blueGrey[800],
                // ),
                onPressed: saveAndNavigate,
                child: const Text('Save',style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}