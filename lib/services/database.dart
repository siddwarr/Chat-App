import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chat_app/models/custom_user.dart';

class DatabaseService {
  final String uid;
  DatabaseService({required this.uid});

  //collection reference - for storing basic user details
  final CollectionReference collectionReference = FirebaseFirestore.instance.collection('users_collection');

<<<<<<< HEAD
  // collection reference - for storing basic user details
  final CollectionReference collectionReference1 = FirebaseFirestore.instance.collection('chat_list_collection');

=======
  //we need to call this function everytime a new user signs up to link their data to their unique id (uid)
>>>>>>> upstream/main
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

  Future createChatList(List<CustomUser> chatList) async {
    return await collectionReference1.doc(uid).set({
      'list': chatList,
    });
  }

  Future addUserToChatList(List<CustomUser> chatList, CustomUser newUser) async {
    chatList.add(newUser);
    return await collectionReference1.doc(uid).set({
      'list': chatList,
    });
  }

  Future deleteUserFromChatList(List<CustomUser> chatList, CustomUser newUser) async {
    return await collectionReference1.doc(uid).set({
      'list': chatList.remove(newUser),
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

  List<CustomUser> _userChatListFromSnapshot(DocumentSnapshot snapshot) {
    return snapshot.get('list');
  }

  Stream<List<CustomUser>> get userChatListStream {
    return collectionReference1.doc(uid).snapshots()
        .map(_userChatListFromSnapshot);
  }
}