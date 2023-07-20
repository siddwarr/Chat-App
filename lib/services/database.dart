import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chat_app/models/custom_user.dart';

class DatabaseService {
  final String uid;
  DatabaseService({required this.uid});

  //collection reference - for storing basic user details
  final CollectionReference collectionReference = FirebaseFirestore.instance.collection('users_collection');

  // collection reference - for storing chat list of a user
  final CollectionReference collectionReference1 = FirebaseFirestore.instance.collection('chat_list_collection');

  Future updateUserData(String email, String password, String name, String username) async {

    //updating the fields name, sugars and strength in the document corresponding to the user's unique id under the collection 'brew'
    return await collectionReference.doc(uid).set({
      'uid': uid,
      'email': email,
      'password': password,
      'name': name,
      'username': username,
    });
  }

  Future createChatList(List<dynamic> chatList) async {
    return await collectionReference1.doc(uid).set({
      'list': chatList,
    });
  }

  Future addUserToChatList(List<dynamic> chatList, CustomUser newUser) async {
    Map<String, String> temp = {};
    temp = newUser.toMap();
    List<String> uidList = [];
    for (dynamic map in chatList) {
      uidList.add(map['uid']);
    }
    if (!uidList.contains(newUser.uid) && newUser.uid != uid) {
      chatList.add(temp);
    }
    return await collectionReference1.doc(uid).set({
      'list': chatList,
    });
  }

  //map the DocumentSnapshot object to a CustomUser object
  CustomUser? _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return CustomUser(
      uid: uid,
      name: snapshot.get('name'),
      username: snapshot.get('username'),
      email: snapshot.get('email'),
      password: snapshot.get('password'),
    );
  }

  //get user doc stream
  //receiving DocumentSnapshot object from Firestore Database (we need to map that to an object of type CustomUser
  Stream<CustomUser?> get userDataStream {
    return collectionReference.doc(uid).snapshots()
        .map(_userDataFromSnapshot);
  }

  //map the QuerySnapshot object to a list of instances of 'Brew' class
  List<CustomUser>? _userDataListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return CustomUser(
        name: doc.get('name') ?? '',
        username: doc.get('username') ?? '',
        email: doc.get('email') ?? '',
        password: doc.get('password') ?? '',
        uid: doc.get('uid') ?? '',
      );
    }).toList();
  }

  //get user data list stream
  Stream<List<CustomUser>?> get userDataListStream {
    return collectionReference.snapshots()
        .map(_userDataListFromSnapshot);
  }

  List<dynamic> _userChatListFromSnapshot(DocumentSnapshot snapshot) {
    return snapshot['list'];
  }

  Stream<List<dynamic>> get userChatListStream {
    return collectionReference1.doc(uid).snapshots()
        .map(_userChatListFromSnapshot);
  }
}