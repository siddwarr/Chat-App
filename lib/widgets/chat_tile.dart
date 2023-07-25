import 'package:chat_app/bottom_navigation_screens/chat_room.dart';
import 'package:chat_app/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/custom_user.dart';
import 'dart:io';

import '../models/json/custom_message.dart';

class ChatTile extends StatefulWidget {
  final CustomUser userData1;
  final Map userData2;
  const ChatTile({super.key, required this.userData1, required this.userData2});

  @override
  State<ChatTile> createState() => _ChatTileState();
}

class _ChatTileState extends State<ChatTile> {

  List maleAvatars = ['assets/male_avatars/male1.jpg', 'assets/male_avatars/male2.jpg', 'assets/male_avatars/male3.jpg', 'assets/male_avatars/male4.jpg', 'assets/male_avatars/male5.jpg', 'assets/male_avatars/male6.jpg', 'assets/male_avatars/male7.jpg'];
  List femaleAvatars = ['assets/female_avatars/female1.jpg', 'assets/female_avatars/female2.jpg', 'assets/female_avatars/female3.jpg', 'assets/female_avatars/female4.jpg', 'assets/female_avatars/female5.jpg', 'assets/female_avatars/female6.jpg', 'assets/female_avatars/female7.jpg'];

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: DatabaseService(uid: widget.userData1.uid, uid2: widget.userData2['uid']).getLastMessage,
      builder: (context, snapshot) {

        if (snapshot.hasData) {
          final lastMessage = snapshot.data?.docs;

          return Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Card(
              margin: const EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0),
              child: ListTile(
                leading: CircleAvatar(
                  radius: 20.0,
                  backgroundImage: widget.userData1.imagePath != ''
                      ? maleAvatars.contains(widget.userData1.imagePath) || femaleAvatars.contains(widget.userData1.imagePath) ? AssetImage(widget.userData1.imagePath.toString()) : Image.file(File(widget.userData1.imagePath)).image
                      : const AssetImage('assets/avatar.png'),
                ),
                title: Text(widget.userData2['username']),
                subtitle: Text(
                  '${(CustomMessage.fromJson(lastMessage![0].data()).fromID) == widget.userData1.uid ? 'You' : widget.userData2['name']}: ${CustomMessage.fromJson(lastMessage[0].data()).message}',
                ),
                onTap: () async {
                  //push the chat room
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatRoom(userData1: widget.userData1, userData2: widget.userData2),
                    ),
                  );
                },
              ),
            ),
          );
        }
        else {
          return Container();
        }
      }
    );
  }
}
