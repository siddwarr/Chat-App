// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously
import 'dart:io';
import 'package:chat_app/bottom_navigation_screens/profile_page.dart';
import 'package:chat_app/bottom_navigation_screens/choose_avatar.dart';
import 'package:chat_app/models/custom_user.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/services/storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// ignore: depend_on_referenced_packages
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:provider/provider.dart';

class UpdateProfilePic extends StatefulWidget {
  final String image;
  final CustomUser? userData;
  const UpdateProfilePic({super.key, required this.image, required this.userData});

  @override
  State<UpdateProfilePic> createState() => _UpdateProfilePicState();
}

class _UpdateProfilePicState extends State<UpdateProfilePic> {

  File? _image;
  final picker = ImagePicker();
  bool isAvatar = false;
  String avatar = '';

  @override
  void initState() {
    super.initState();
    _image = File(widget.image);
  }

  Future getImageFromGallery() async {
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
  Future getImageFromCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
      else {
        print('No image selected.');
      }
    });
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
                      onPressed: getImageFromCamera,
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
                      onPressed: getImageFromGallery,
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
                    onPressed: () async {
                      avatar = await Navigator.pushNamed(context, '/choose_avatar') as String;
                      setState(() {
                        _image = File(avatar);
                        isAvatar = true;
                      });
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
                      onPressed: () async {
                        setState(() {
                          _image = File('');
                        });
                        //delete the user's current profile pic and set imagePath of current user to ''
                        await StorageService(uid: widget.userData!.uid, image: _image).deleteFile();
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
            onPressed: () async {
              //confirm selection - before popping the bottom sheet, we need to update our cloud storage according the chosen image
              if (isAvatar) {
                ByteData imageBytes = await rootBundle.load(avatar);
                Uint8List imageData = imageBytes.buffer.asUint8List(imageBytes.offsetInBytes, imageBytes.lengthInBytes);
                await StorageService(uid: widget.userData!.uid, image: _image).uploadAsset(imageData);
              }
              else {
                await StorageService(uid: widget.userData!.uid, image: _image).uploadFile();
              }
              await DatabaseService(uid: widget.userData!.uid).updateUserData(widget.userData!.email, widget.userData!.password, widget.userData!.name, widget.userData!.username, _image!.path);
              Navigator.pop(context); //popping the bottom sheet
            },
            child: const Text("Confirm"),
          ),
        ),
      ],
    );
  }
}
