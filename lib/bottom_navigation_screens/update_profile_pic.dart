// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously
import 'dart:io';
import 'package:chat_app/bottom_navigation_screens/profile_page.dart';
import 'package:chat_app/bottom_navigation_screens/choose_avatar.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UpdateProfilePic extends StatefulWidget {
  final File? image;

  const UpdateProfilePic({super.key, this.image});

  @override
  State<UpdateProfilePic> createState() => _UpdateProfilePicState();
}

class _UpdateProfilePicState extends State<UpdateProfilePic> {

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
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //take photo
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  const CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(Icons.camera_alt),
                  ),
                  Center(
                    child: TextButton(
                      onPressed: () {},
                      child: const Text('Take Photo', textAlign: TextAlign.center),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 10.0,
            ),
            //from gallery
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  const CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(Icons.photo),
                  ),
                  Center(
                    child: TextButton(
                      onPressed: getImage,
                      child: const Text('Gallery', textAlign: TextAlign.center),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 10.0,
            ),
            //choose avatar
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  const CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ChooseAvatar(),
                        ),
                      );
                    },
                    child: const Text('Avatar', textAlign: TextAlign.center),
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 10.0,
            ),
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  const CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(Icons.clear),
                  ),
                  Center(
                    child: TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('No profile photo', textAlign: TextAlign.center),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(
          width: 350.0,
          //height: 100.0,
          child: OutlinedButton(
            onPressed: () {
              //confirm selection
              Navigator.pop(context); //popping the bottom sheet
            },
            child: const Text("Continue"),
          ),
        ),
      ],
    );
  }
}
