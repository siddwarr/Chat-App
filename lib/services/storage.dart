import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  final String uid;
  final File? image;
  StorageService({required this.uid, required this.image});

  final FirebaseStorage firebaseStorage = FirebaseStorage.instance;

  Future uploadProfilePic(String userUID, String folder) async {
    if (image == null) {
      print('No image selected.');
      return;
    }

    String fileName = userUID;
    Reference reference = FirebaseStorage.instance.ref(folder).child(fileName);
    UploadTask uploadTask = reference.putFile(image!);
    TaskSnapshot storageTaskSnapshot = await uploadTask.whenComplete(() {});
    String imageUrl = await storageTaskSnapshot.ref.getDownloadURL();

    // Perform actions with the uploaded image URL
    print('Image URL: $imageUrl');
  }

  Future uploadImage(String sent, String folder) async {
    if (image == null) {
      print('No image selected.');
      return;
    }

    String fileName = sent;
    Reference reference = FirebaseStorage.instance.ref(folder).child(fileName);
    UploadTask uploadTask = reference.putFile(image!);
    TaskSnapshot storageTaskSnapshot = await uploadTask.whenComplete(() {});
    String imageUrl = await storageTaskSnapshot.ref.getDownloadURL();

    // Perform actions with the uploaded image URL
    print('Image URL: $imageUrl');
  }

  Future uploadAsset(Uint8List imageData) async {
    if (image == null) {
      print('No image selected.');
      return;
    }

    String fileName = uid;
    Reference reference = FirebaseStorage.instance.ref('profile_pics').child(fileName);
    UploadTask uploadTask = reference.putData(imageData);
    TaskSnapshot storageTaskSnapshot = await uploadTask.whenComplete(() {});
    String imageUrl = await storageTaskSnapshot.ref.getDownloadURL();

    // Perform actions with the uploaded image URL
    print('Image URL: $imageUrl');
  }

  Future deleteFile(String folder, String fileName) async {
    Reference reference = FirebaseStorage.instance.ref(folder).child(fileName);
    try {
      await reference.delete();
    }
    catch (e) {
      print('File not found.');
    }
  }
}