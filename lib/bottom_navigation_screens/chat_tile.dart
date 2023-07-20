import 'package:chat_app/bottom_navigation_screens/chat_room.dart';
import 'package:flutter/material.dart';
import '../models/custom_user.dart';

class ChatTile extends StatefulWidget {
  final CustomUser userData1;
  final Map userData2;
  const ChatTile({super.key, required this.userData1, required this.userData2});

  @override
  State<ChatTile> createState() => _ChatTileState();
}

class _ChatTileState extends State<ChatTile> {
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
          title: Text(widget.userData2['username']),
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
}
