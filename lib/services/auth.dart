import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:chat_app/models/custom_user.dart';
import 'package:chat_app/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthService {
  //creating an instance of the FirebaseAuth class (which we imported)
  final FirebaseAuth _auth = FirebaseAuth.instance; //the '_' in the beginning signifies that this is a private property

  //from the 'User' object, we only require the 'uid' of the user => we use an object of our own custom class which stores the 'uid' as a parameter
  //this function will return an object of our custom class - CustomUser by extracting only the 'uid' property from the 'User' object
  UserUID? _func1(User user) {
    return UserUID(uid: user.uid);
  }

  getData(User user) async {
    DocumentSnapshot documentSnapshot = await DatabaseService(uid: user.uid).collectionReference.doc(user.uid).get();
    return documentSnapshot;
  }

  //auth change user stream
  //stream - stream between the flutter app and firebase auth service
  //firebase auth service will send either null or some User object through the stream whenever a user signs out or signs in
  //we have to receive this object and determine based on its value whether the user is logged in or logged out to update the UI accordingly
  Stream<UserUID?> get user {

    //everytime we get a User object from the stream, we are going to map that to a CustomUser object
    return _auth.authStateChanges() //this function detects authentication changes
        .map((User? user) => _func1(user!));
  }

  //sign-in with email and password
  Future signInWithEmailPassword(String email, String password) async {
    try {
      //make a request to Firebase
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password); //signing the user in with the given email and password
      User? user = result.user; //getting the user credentials
      return _func1(user!); //mapping it to an object of CustomUser and returning it
    }
    catch (e) {
      print(e.toString());
      return null;
    }
  }
  //register with email and password
  Future registerWithEmailPassword(String email, String password, String name, String username) async {
    try {
      //make a request to Firebase
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password); //creating an account for the user with the given email and password
      User? user = result.user; //getting the user credentials

      //as soon as the user registers, we create a new document against their uid containing their name and username
      await DatabaseService(uid: user!.uid).updateUserData(email, password, name, username);

      return _func1(user); //mapping it to an object of CustomUser and returning it
    }
    catch (e) {
      print(e.toString());
      return null;
    }
  }
  //sign-out
  Future signOut() async {
    try {
      return await _auth.signOut(); //built-in method in the firebase-auth package
    }
    catch (e) {
      print(e.toString());
      return null;
    }
  }
}