import 'package:chat_app/screens/chat_room.dart';
import 'package:chat_app/screens/loading.dart';
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

  String getFormattedTime({required BuildContext context, required String time}) {
    final date = DateTime.fromMillisecondsSinceEpoch(int.parse(time));
    return TimeOfDay.fromDateTime(date).format(context);
  }

  List maleAvatars = ['assets/male_avatars/male1.jpg', 'assets/male_avatars/male2.jpg', 'assets/male_avatars/male3.jpg', 'assets/male_avatars/male4.jpg', 'assets/male_avatars/male5.jpg', 'assets/male_avatars/male6.jpg', 'assets/male_avatars/male7.jpg'];
  List femaleAvatars = ['assets/female_avatars/female1.jpg', 'assets/female_avatars/female2.jpg', 'assets/female_avatars/female3.jpg', 'assets/female_avatars/female4.jpg', 'assets/female_avatars/female5.jpg', 'assets/female_avatars/female6.jpg', 'assets/female_avatars/female7.jpg'];

  int unread = 0;
  String lastMessage = '', lastImage = '', sent = '', fromID = '';
  bool isVisible = true;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: DatabaseService(uid: widget.userData1.uid, uid2: widget.userData2['uid']).getAllMessages,
      builder: (context, snapshot) {

        if (snapshot.hasData) {

          final list = snapshot.data?.docs;
          if (snapshot.data!.docs.isNotEmpty) {
            //traversing the list of all messages in reverse order until we encounter the first 'visible' message
            for (int i = list!.length - 1; i >= 0; i--) {
              if (list[i].data()['visibleTo'].contains(widget.userData1.uid)) {
                lastMessage = list[i].data()['message'];
                lastImage = list[i].data()['image'];
                sent = list[i].data()['sent'];
                fromID = list[i].data()['fromID'];
                break;
              }
            }
          }
          //traversing the list of all messages in reverse order until we encounter a read message
          unread = 0;
          for (int i = list!.length - 1; i >= 0; i--) {
            //we have to mark all the messages sent my the other user as read
            if (list[i].data()['fromID'] != widget.userData1.uid) {
              if (list[i].data()['read'] == '') {
                unread++;
              }
              else {
                break;
              }
            }
          }

          return Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Card(
              margin: const EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0),
              child: ListTile(
                leading: CircleAvatar(
                  radius: 20.0,
                  backgroundImage: widget.userData2['image'] != ''
                      ? maleAvatars.contains(widget.userData2['image']) || femaleAvatars.contains(widget.userData2['image']) ? AssetImage(widget.userData2['image'].toString()) : Image.file(File(widget.userData2['image'])).image
                      : const AssetImage('assets/avatar.png'),
                ),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(widget.userData2['username']),
                    Text(
                      sent == '' ? '' : getFormattedTime(context: context, time: sent),
                      style: const TextStyle(
                        fontSize: 13.0,
                      ),
                    ),
                  ],
                ),
                subtitle: Row(
                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    lastMessage == ''
                    ?
                    lastImage == ''
                    ?
                    const SizedBox.shrink()
                    :
                    fromID == widget.userData1.uid
                    ?
                    Row(
                      children: [
                        Icon(Icons.done_all, size: 15, color: snapshot.data?.docs[snapshot.data!.docs.length - 1].data()['read'] == '' ? Colors.grey : Colors.blue),
                        const SizedBox(width: 5),
                      ],
                    )
                    :
                    const SizedBox.shrink()
                    :
                    fromID == widget.userData1.uid
                    ?
                    Row(
                      children: [
                        Icon(Icons.done_all, size: 15, color: snapshot.data?.docs[snapshot.data!.docs.length - 1].data()['read'] == '' ? Colors.grey : Colors.blue),
                        const SizedBox(width: 5),
                      ],
                    )
                    :
                    const SizedBox.shrink(),


                    lastMessage == ''
                    ?
                    lastImage == ''
                    ?
                    const Text('')
                    :
                    const Row(
                      children: [
                        Icon(Icons.photo, size: 16),
                        SizedBox(
                          width: 5,
                        ),
                        Text('Photo'),
                      ],
                    )
                    :
                    Text(lastMessage),

                    const Spacer(),

                    unread == 0 ?
                    const Text('')
                    :
                    CircleAvatar(
                      radius: 13.0,
                      backgroundColor: Colors.green,
                      child: Text('$unread'),
                    )
                  ],
                ),
                onTap: () async {
                  //push the chat room
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatRoom(userData1: widget.userData1, userData2: widget.userData2, list: list),
                    ),
                  );
                  setState(() {
                    unread = 0;
                  });
                  //when a particular conversation is clicked, all messages sent in it until now should be considered read
                  final time  = DateTime.now();
                  //traversing the list of all messages in reverse order until we encounter a read message
                  for (int i = list.length - 1; i >= 0; i--) {
                    //we have to mark all the messages sent my the other user as read
                    if (list[i].data()['fromID'] != widget.userData1.uid) {
                      if (list[i].data()['read'] == '') {
                        await DatabaseService(uid: widget.userData1.uid).updateMessage(CustomMessage.fromJson(list[i].data()), time.millisecondsSinceEpoch.toString(), false, snapshot.data?.docs[snapshot.data!.docs.length - 1].data()['visibleTo']);
                      }
                      else {
                        break;
                      }
                    }
                  }
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
