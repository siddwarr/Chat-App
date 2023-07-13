import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chat_app/models/custom_user.dart';

class DatabaseService {
  final String uid;
  DatabaseService({required this.uid});

  //collection reference
  final CollectionReference collectionReference = FirebaseFirestore.instance.collection('users_collection'); //brew - name of collection

  //we need to call this function everytime a new user signs up to link their data to their unique id (uid)
  Future updateUserData(String name, String username) async {

    //updating the fields name, sugars and strength in the document corresponding to the user's unique id under the collection 'brew'
    return await collectionReference.doc(uid).set({
      'name': name,
      'username': username,
    });
  }

  //map the DocumentSnapshot object to a CustomUser object
  CustomUser? _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return CustomUser(
      uid: uid,
      name: snapshot.get('name'),
      username: snapshot.get('username'),
    );
  }

  //get user doc stream
  //receiving DocumentSnapshot object from Firestore Database (we need to map that to an object of type CustomUser
  Stream<CustomUser?> get userDataStream {
    return collectionReference.doc(uid).snapshots()
        .map(_userDataFromSnapshot);
  }
}