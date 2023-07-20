import 'package:chat_app/models/custom_user.dart';
import 'package:chat_app/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchTile extends StatelessWidget {
  
  final CustomUser userData;
  final CustomUser currentUserData;
  final List<dynamic> userChatList;
  SearchTile({super.key, required this.userData, required this.userChatList, required this.currentUserData});

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Card(
        margin: const EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0),
        child: ListTile(
          leading: const CircleAvatar(
            radius: 20.0,
            child: Icon(Icons.person),
          ),
          title: Text(userData.username),
          subtitle: Text(userData.name),
          onTap: () async {
            //add that user to current user's chat list
            await DatabaseService(uid: currentUserData.uid).addUserToChatList(userChatList, userData);
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}
