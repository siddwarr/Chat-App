import 'dart:core';
import 'dart:io';
import 'package:chat_app/models/json/custom_message.dart';
import 'package:chat_app/services/storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chat_app/models/custom_user.dart';

class DatabaseService {
  final String uid;
  String? uid2;
  DatabaseService({required this.uid, this.uid2});

  //collection reference - for storing basic user details
  final CollectionReference collectionReference = FirebaseFirestore.instance.collection('users_collection');

  // collection reference - for storing chat list of a user
  final CollectionReference collectionReference1 = FirebaseFirestore.instance.collection('chat_list_collection');
  
  Future updateUserData(String email, String password, String name, String username, String imagePath) async {

    //updating the fields name, sugars and strength in the document corresponding to the user's unique id under the collection 'brew'
    return await collectionReference.doc(uid).set({
      'uid': uid,
      'email': email,
      'password': password,
      'name': name,
      'username': username,
      'image': imagePath,
    });
  }

  Future createChatList(List<dynamic> chatList) async {
    return await collectionReference1.doc(uid).set({
      'list': chatList,
    });
  }

  Future addUserToChatList(String userUID, List<dynamic> chatList, CustomUser newUser) async {
    //here, user represents the user whose chat list the new user is to be added to
    Map<String, String> temp = {};
    temp = newUser.toMap();
    List<String> uidList = [];
    for (dynamic map in chatList) {
      uidList.add(map['uid']);
    }
    if (!uidList.contains(newUser.uid) && newUser.uid != userUID) {
      chatList.add(temp);
    }
    return await collectionReference1.doc(userUID).set({
      'list': chatList,
    });
  }

  Future obtainChatList(String userUID) async {
    var docSnap =  await collectionReference1.doc(userUID).get();
    List<dynamic> chatList = docSnap.get('list');
    return chatList;
  }

  //map the DocumentSnapshot object to a CustomUser object
  CustomUser? _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return CustomUser(
      uid: uid,
      name: snapshot.get('name'),
      username: snapshot.get('username'),
      email: snapshot.get('email'),
      password: snapshot.get('password'),
      imagePath: snapshot.get('image'),
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
        imagePath: doc.get('image') ?? '',
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




  //unique id for a particular conversation between 2 users
  String getConversationID(String uid1, String uid2) => uid1.hashCode <= uid2.hashCode
      ? '${uid1}_$uid2'
      : '${uid2}_$uid1';

  //stream for obtaining all messages in a particular conversation (with a unique conversation id) between 2 users
  Stream<QuerySnapshot<Map<String, dynamic>>> get getAllMessages {
    return FirebaseFirestore.instance.collection('chat_collection/${getConversationID(uid, uid2!)}/messages')
        .orderBy('sent', descending: false).snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> get getLastMessage {
    //limit(1) => the last document among the list of all documents in our collection sorted in descending order (according to the time the message was sent)
    //we are essentially trying to obtain the most recent message that was shared in a particular conversation
    return FirebaseFirestore.instance.collection('chat_collection/${getConversationID(uid, uid2!)}/messages')
        .orderBy('sent', descending: true).limit(1).snapshots();
  }

  Future<void> updateMessage(CustomMessage message, String read, bool isSelected, List<dynamic> visibleTo) async {

    final CustomMessage customMessage = CustomMessage(fromID: message.fromID, toID: message.toID, message: message.message, image: message.image, type: message.type, read: read, sent: message.sent, replyTo: message.replyTo, imageReply: message.imageReply, textReply: message.textReply, isSelected: isSelected, visibleTo: visibleTo);

    //we have to convert this object to JSON before adding it to our collection 'messages'
    //each document within this collection is going to represent a particular message (the document will be named after the exact time at which that message was sent)
    await FirebaseFirestore.instance.collection('chat_collection/${getConversationID(message.fromID, message.toID)}/messages').doc(message.sent).set(customMessage.toJson());
  }

  Future<void> sendFirstMessage(CustomUser currentUser, List<dynamic> chatList, String message, DateTime time) async {
    //since this is the first message that current user is sending to the other user, we must add the current user to the chat list of the other user before adding the message to the chat collection
    await addUserToChatList(uid2!, chatList, currentUser);

    final CustomMessage customMessage = CustomMessage(fromID: uid, toID: uid2!, message: message, image: '', type: 'text', read: '', sent: time.millisecondsSinceEpoch.toString(), replyTo: '', imageReply: '', textReply: '', isSelected: false, visibleTo: [uid, uid2!]);

    //we have to convert this object to JSON before adding it to our collection 'messages'
    //each document within this collection is going to represent a particular message (the document will be named after the exact time at which that message was sent)
    await FirebaseFirestore.instance.collection('chat_collection/${getConversationID(uid, uid2!)}/messages').doc(time.millisecondsSinceEpoch.toString()).set(customMessage.toJson());
  }

  Future<void> sendFirstImage(CustomUser currentUser, List<dynamic> chatList, String image, DateTime time) async {
    //since this is the first message that current user is sending to the other user, we must add the current user to the chat list of the other user before adding the message to the chat collection
    await addUserToChatList(uid2!, chatList, currentUser);

    final CustomMessage customMessage = CustomMessage(fromID: uid, toID: uid2!, message: '', image: image, type: 'image', read: '', sent: time.millisecondsSinceEpoch.toString(), replyTo: '', imageReply: '', textReply: '', isSelected: false, visibleTo: [uid, uid2!]);

    //we have to convert this object to JSON before adding it to our collection 'messages'
    //each document within this collection is going to represent a particular message (the document will be named after the exact time at which that message was sent)
    await FirebaseFirestore.instance.collection('chat_collection/${getConversationID(uid, uid2!)}/messages').doc(time.millisecondsSinceEpoch.toString()).set(customMessage.toJson());
    await StorageService(uid: uid, image: File(image)).uploadImage(time.millisecondsSinceEpoch.toString(), 'chat_images/${getConversationID(uid, uid2!)}/images');
  }

  Future<void> sendMessage(String message, DateTime time, String replyTo, String imageReply, String textReply) async {
    final CustomMessage customMessage = CustomMessage(fromID: uid, toID: uid2!, message: message, image: '', type: 'text', read: '', sent: time.millisecondsSinceEpoch.toString(), replyTo: replyTo, imageReply: imageReply, textReply: textReply, isSelected: false, visibleTo: [uid, uid2!]);

    //we have to convert this object to JSON before adding it to our collection 'messages'
    //each document within this collection is going to represent a particular message (the document will be named after the exact time at which that message was sent)
    await FirebaseFirestore.instance.collection('chat_collection/${getConversationID(uid, uid2!)}/messages').doc(time.millisecondsSinceEpoch.toString()).set(customMessage.toJson());
  }

  Future<void> sendImage(String image, DateTime time, String replyTo, String imageReply, String textReply) async {
    final CustomMessage customMessage = CustomMessage(fromID: uid, toID: uid2!, message: '', image: image, type: 'image', read: '', sent: time.millisecondsSinceEpoch.toString(), replyTo: replyTo, imageReply: imageReply, textReply: textReply, isSelected: false, visibleTo: [uid, uid2!]);

    //we have to convert this object to JSON before adding it to our collection 'messages'
    //each document within this collection is going to represent a particular message (the document will be named after the exact time at which that message was sent)
    await FirebaseFirestore.instance.collection('chat_collection/${getConversationID(uid, uid2!)}/messages').doc(time.millisecondsSinceEpoch.toString()).set(customMessage.toJson());
    await StorageService(uid: uid, image: File(image)).uploadImage(time.millisecondsSinceEpoch.toString(), 'chat_images/${getConversationID(uid, uid2!)}/images');
  }

  Future<void> deleteMessage(CustomMessage customMessage) async {
    await FirebaseFirestore.instance.collection('chat_collection/${getConversationID(uid, uid2!)}/messages').doc(customMessage.sent).delete();
  }

  Future<void> deleteImage(CustomMessage customMessage) async {
    await FirebaseFirestore.instance.collection('chat_collection/${getConversationID(uid, uid2!)}/messages').doc(customMessage.sent).delete();
    //apart from deleting the document from the collection, we also must delete the corresponding file from our storage
    await StorageService(uid: uid, image: File(customMessage.image)).deleteFile('chat_images/${getConversationID(uid, uid2!)}/images', customMessage.sent);
  }
}