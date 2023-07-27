import 'package:flutter/material.dart';
import 'dart:io';
import '../models/custom_user.dart';
import '../models/json/custom_message.dart';
import '../services/database.dart';

class SendImage extends StatefulWidget {
  final CustomUser userData1;
  final Map userData2;
  final String image;
  SendImage({required this.image, required this.userData1, required this.userData2});

  @override
  State<SendImage> createState() => _SendImageState();
}

class _SendImageState extends State<SendImage> {

  final TextEditingController _controller = TextEditingController();
  late DateTime time;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20.0, right: 10.0),
            child: Align(
              alignment: Alignment.topRight,
              child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.clear),
              ),
            ),
          ),
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 30.0),
              child: Image.file(File(widget.image)),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.only(left: 10, bottom: 10, top: 10, right: 5),
              height: 75,
              width: double.infinity,
              child: Row(
                children: [
                  Flexible(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        hintText: 'Message',
                      ),
                    ),
                  ),
                  FloatingActionButton.small(
                    onPressed: () async {

                      time = DateTime.now();
                      //case 1: the list is empty and this is the first message of the conversation (we have to add current user to the chat list of the other user and then send the message)
                      final chatList = await DatabaseService(uid: widget.userData1.uid).obtainChatList(widget.userData2['uid']);
                      await DatabaseService(uid: widget.userData1.uid, uid2: widget.userData2['uid']).sendFirstImage(widget.userData1, chatList, widget.image, time);
                      //case 2: the list is not empty
                      await DatabaseService(uid: widget.userData1.uid, uid2: widget.userData2['uid']).sendImage(widget.image, time, '', '');

                    },
                    child: const Icon(Icons.send, size: 20.0),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
