import 'dart:io';
import 'package:chat_app/services/database.dart';
import 'package:flutter/material.dart';
import '../models/custom_user.dart';
import '../models/json/custom_message.dart';

class MessageCard extends StatefulWidget {
  final CustomUser userData1;
  final Map userData2;
  final CustomMessage message;
  final int selected;
  MessageCard({required this.userData1, required this.userData2, required this.message, required this.selected});

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {

  String getFormattedTime({required BuildContext context, required String time}) {
    final date = DateTime.fromMillisecondsSinceEpoch(int.parse(time));
    return TimeOfDay.fromDateTime(date).format(context);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.message.fromID == widget.userData1.uid && widget.message.image == '') {
      return _greenMessage();
    }
    else if (widget.message.fromID != widget.userData1.uid && widget.message.image == '') {
      return _blueMessage();
    }
    else if (widget.message.fromID == widget.userData1.uid && widget.message.image != '') {
      return _greenImage();
    }
    else {
      return _blueImage();
    }
  }

  Widget _blueMessage() {
    return Container(
      margin: const EdgeInsets.only(top: 5),
      color: widget.message.isSelected ? Colors.lightBlueAccent : Colors.white,
      child: GestureDetector(
        onLongPress: () async {
          if (widget.selected == 0) {
            //here, we have to update the 'selected' property of the current message to true
            await DatabaseService(uid: widget.userData1.uid, uid2: widget.userData2['uid']).updateMessage(widget.message, widget.message.read, true, widget.message.visibleTo);
          }
        },
        onTap: () async {
          if (widget.selected > 0) {
            //at least 1 message is selected => negate the selected status of the tapped message
            await DatabaseService(uid: widget.userData1.uid, uid2: widget.userData2['uid']).updateMessage(widget.message, widget.message.read, !widget.message.isSelected, widget.message.visibleTo);
          }
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            //message content
            Flexible(
              child: Container(
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 221, 245, 255),
                    border: Border.all(color: Colors.lightBlue),
                    //making borders curved
                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25), bottomRight: Radius.circular(25)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.message.message,
                      style: const TextStyle(fontSize: 16, color: Colors.black87),
                    ),
                    const SizedBox(
                      height: 5.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          getFormattedTime(context: context, time: widget.message.sent),
                          style: const TextStyle(fontSize: 12, color: Colors.black54),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _greenMessage() {
    return Container(
      margin: const EdgeInsets.only(top: 5),
      color: widget.message.isSelected ? Colors.lightBlueAccent : Colors.white,
      child: GestureDetector(
        onLongPress: () async {
          if (widget.selected == 0) {
            //here, we have to update the 'selected' property of the current message to true
            await DatabaseService(uid: widget.userData1.uid, uid2: widget.userData2['uid']).updateMessage(widget.message, widget.message.read, true, widget.message.visibleTo);
          }
        },
        onTap: () async {
          if (widget.selected > 0) {
            //at least 1 message is selected => negate the selected status of the tapped message
            await DatabaseService(uid: widget.userData1.uid, uid2: widget.userData2['uid']).updateMessage(widget.message, widget.message.read, !widget.message.isSelected, widget.message.visibleTo);
          }
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            //message content
            Flexible(
              child: Container(
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 218, 255, 176),
                  border: Border.all(color: Colors.lightGreen),
                  //making borders curved
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25), bottomLeft: Radius.circular(25)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      widget.message.message,
                      style: const TextStyle(fontSize: 16, color: Colors.black87),
                    ),
                    const SizedBox(
                      height: 5.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          getFormattedTime(context: context, time: widget.message.sent),
                          style: const TextStyle(fontSize: 12, color: Colors.black54),
                        ),
                        const SizedBox(width: 5),
                        Icon(Icons.done_all, size: 15, color: widget.message.read == '' ? Colors.grey : Colors.blue),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _blueImage() {
    return Container(
      margin: const EdgeInsets.only(top: 5),
      color: widget.message.isSelected ? Colors.lightBlueAccent : Colors.white,
      child: GestureDetector(
        onLongPress: () async {
          if (widget.selected == 0) {
            //here, we have to update the 'selected' property of the current message to true
            await DatabaseService(uid: widget.userData1.uid, uid2: widget.userData2['uid']).updateMessage(widget.message, widget.message.read, true, widget.message.visibleTo);
          }
        },
        onTap: () async {
          if (widget.selected > 0) {
            //at least 1 message is selected => negate the selected status of the tapped message
            await DatabaseService(uid: widget.userData1.uid, uid2: widget.userData2['uid']).updateMessage(widget.message, widget.message.read, !widget.message.isSelected, widget.message.visibleTo);
          }
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            //message content
            Flexible(
              child: Container(
                height: 280,
                width: 200,
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 221, 245, 255),
                  border: Border.all(color: Colors.lightBlue),
                  //making borders curved
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25), bottomRight: Radius.circular(25)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.file(File(widget.message.image)),
                    const SizedBox(
                      height: 5.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          getFormattedTime(context: context, time: widget.message.sent),
                          style: const TextStyle(fontSize: 12, color: Colors.black54),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _greenImage() {
    return Container(
      margin: const EdgeInsets.only(top: 5),
      color: widget.message.isSelected ? Colors.lightBlueAccent : Colors.white,
      child: GestureDetector(
        onLongPress: () async {
          if (widget.selected == 0) {
            //here, we have to update the 'selected' property of the current message to true
            await DatabaseService(uid: widget.userData1.uid, uid2: widget.userData2['uid']).updateMessage(widget.message, widget.message.read, true, widget.message.visibleTo);
          }
        },
        onTap: () async {
          if (widget.selected > 0) {
            //at least 1 message is selected => negate the selected status of the tapped message
            await DatabaseService(uid: widget.userData1.uid, uid2: widget.userData2['uid']).updateMessage(widget.message, widget.message.read, !widget.message.isSelected, widget.message.visibleTo);
          }
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            //message content
            Flexible(
              child: Container(
                height: 280,
                width: 200,
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 218, 255, 176),
                  border: Border.all(color: Colors.lightGreen),
                  //making borders curved
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25), bottomLeft: Radius.circular(25)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Image.file(File(widget.message.image)),
                    const SizedBox(
                      height: 5.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          getFormattedTime(context: context, time: widget.message.sent),
                          style: const TextStyle(fontSize: 12, color: Colors.black54),
                        ),
                        const SizedBox(width: 5),
                        Icon(Icons.done_all, size: 15, color: widget.message.read == '' ? Colors.grey : Colors.blue),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
