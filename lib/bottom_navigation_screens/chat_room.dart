import 'package:chat_app/models/json/custom_message.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/widgets/message_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/custom_user.dart';

class ChatRoom extends StatefulWidget {
  final CustomUser userData1;
  final Map userData2;
  final List<QueryDocumentSnapshot<Map<String, dynamic>>>? list;
  const ChatRoom({super.key, required this.userData1, required this.userData2, required this.list});

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {

  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late DateTime time;
  bool isReverse = true;

  @override
  Widget build(BuildContext context) {

    if (_scrollController.hasClients) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    }

    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: DatabaseService(uid: widget.userData1.uid, uid2: widget.userData2['uid']).getAllMessages,
      builder: (context, snapshot) {

        if (snapshot.hasData) {
          
          final list = snapshot.data?.docs;

          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                iconSize: 20.0,
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              title: Text(
                widget.userData2['name'],
              ),
            ),
            body: Stack(
              children: [
                Container(
                  padding: const EdgeInsets.only(bottom: 75),
                  child: ListView.builder(
                    reverse: isReverse,
                    controller: _scrollController,
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: list?.length,
                    itemBuilder: (context, index) {
                      if (isReverse) {
                        return MessageCard(userData1: widget.userData1, userData2: widget.userData2, message: CustomMessage.fromJson(list![list.length - index - 1].data()));
                      }
                      else {
                        return MessageCard(userData1: widget.userData1, userData2: widget.userData2, message: CustomMessage.fromJson(list![index].data()));
                      }
                    },
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
                        const SizedBox(
                          width: 10.0,
                        ),
                        FloatingActionButton(
                          onPressed: () async {

                            time = DateTime.now();
                            //case 1: the list is empty and this is the first message of the conversation (we have to add current user to the chat list of the other user and then send the message)
                            final chatList = await DatabaseService(uid: widget.userData1.uid).obtainChatList(widget.userData2['uid']);
                            await DatabaseService(uid: widget.userData1.uid, uid2: widget.userData2['uid']).sendFirstMessage(widget.userData1, chatList, _controller.text, 'text', time);
                            //case 2: the list is not empty
                            await DatabaseService(uid: widget.userData1.uid, uid2: widget.userData2['uid']).sendMessage(_controller.text, 'text', time);

                            setState(() {
                              isReverse = false;
                              _scrollController.animateTo(_scrollController.position.maxScrollExtent, duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
                              _controller.clear();
                            });
                          },
                          child: const Icon(Icons.send),
                        )
                      ],
                    ),
                  ),
                )
              ],
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
