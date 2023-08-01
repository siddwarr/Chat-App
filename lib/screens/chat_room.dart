import 'dart:io';
import 'package:chat_app/models/json/custom_message.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/widgets/message_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/custom_user.dart';
import 'send_image.dart';

class ChatRoom extends StatefulWidget {
  final CustomUser userData1;
  final Map userData2;
  final List<QueryDocumentSnapshot<Map<String, dynamic>>>? list;
  const ChatRoom({super.key, required this.userData1, required this.userData2, required this.list});

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {

  File? _image;
  final picker = ImagePicker();

  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late DateTime time;
  bool isReverse = true, deleteForEveryone = true;
  int selected = 0;

  List maleAvatars = ['assets/male_avatars/male1.jpg', 'assets/male_avatars/male2.jpg', 'assets/male_avatars/male3.jpg', 'assets/male_avatars/male4.jpg', 'assets/male_avatars/male5.jpg', 'assets/male_avatars/male6.jpg', 'assets/male_avatars/male7.jpg'];
  List femaleAvatars = ['assets/female_avatars/female1.jpg', 'assets/female_avatars/female2.jpg', 'assets/female_avatars/female3.jpg', 'assets/female_avatars/female4.jpg', 'assets/female_avatars/female5.jpg', 'assets/female_avatars/female6.jpg', 'assets/female_avatars/female7.jpg'];

  @override
  Widget build(BuildContext context) {

    Future getImageFromCamera() async {
      final pickedFile = await picker.pickImage(source: ImageSource.camera);
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        //if the user has selected a picture, we push a screen that displays the image to be sent along with a text field to type in a message along with the image, and finally the send button
        setState(() {
          //isReverse = false;
          _scrollController.animateTo(_scrollController.position.minScrollExtent, duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
          _controller.clear();
        });
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => SendImage(image: _image, userData1: widget.userData1, userData2: widget.userData2)));
      }
      else {
        print('No image selected.');
      }
    }

    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: DatabaseService(uid: widget.userData1.uid, uid2: widget.userData2['uid']).getAllMessages,
      builder: (context, snapshot) {

        if (snapshot.hasData) {
          
          final list = snapshot.data?.docs;

          selected = 0;
          deleteForEveryone = true;

          //iterating through the messages to find the number of messages selected
          for (int i = 0; i < list!.length; i++) {
            if (CustomMessage.fromJson(list[i].data()).isSelected) {
              //check if the selected message was sent by the other party
              if (CustomMessage.fromJson(list[i].data()).fromID != widget.userData1.uid) {
                deleteForEveryone = false;
              }
              selected++;
            }
          }

          final AppBar appBar2 =  AppBar(
            leading: IconButton(
              icon: const Icon(Icons.clear),
              iconSize: 20.0,
              onPressed: () async {
                //on pressing this, all messages currently selected must be de-selected and we must also revert to our original app bar
                setState(() {
                  selected = 0;
                });
                for (int i = 0; i < list.length; i++) {
                  if (CustomMessage.fromJson(list[i].data()).isSelected) {
                    DatabaseService(uid: widget.userData1.uid, uid2: widget.userData2['uid']).updateMessage(CustomMessage.fromJson(list[i].data()), CustomMessage.fromJson(list[i].data()).read, false, CustomMessage.fromJson(list[i].data()).visibleTo);
                  }
                }
              },
            ),
            title: Text('$selected'),
            actions: [
              selected == 1
              ?
              GestureDetector(
                onTap: () {

                },
                child: Container(
                  padding: const EdgeInsets.only(top: 5),
                  //height: 20,
                  width: 20,
                  child: Image.asset('assets/reply.png', color: Colors.white),
                ),
              )
              :
              const SizedBox.shrink(),
              
              
              IconButton(
                onPressed: () async {
                  showDialog(context: context, builder: (context) {
                    return AlertDialog(
                      title: Text('Do you want to delete $selected messages?'),
                      actions: [
                        deleteForEveryone
                        ?
                        TextButton(
                          onPressed: () async {
                            setState(() {
                              selected = 0;
                            });
                            for (int i = 0; i < list.length; i++) {
                              if (CustomMessage.fromJson(list[i].data()).isSelected) {
                                if (CustomMessage.fromJson(list[i].data()).image != '') {
                                  await DatabaseService(uid: widget.userData1.uid, uid2: widget.userData2['uid']).deleteImage(CustomMessage.fromJson(list[i].data()));
                                }
                                else {
                                  await DatabaseService(uid: widget.userData1.uid, uid2: widget.userData2['uid']).deleteMessage(CustomMessage.fromJson(list[i].data()));
                                }
                              }
                            }
                            Navigator.pop(context);
                          },
                          child: const Text('Delete for everyone'),
                        )
                        :
                        const SizedBox.shrink(),
                        TextButton(
                          onPressed: () async {
                            setState(() {
                              selected = 0;
                            });
                            for (int i = 0; i < list.length; i++) {
                              if (CustomMessage.fromJson(list[i].data()).isSelected) {
                                await DatabaseService(uid: widget.userData1.uid, uid2: widget.userData2['uid']).updateMessage(CustomMessage.fromJson(list[i].data()), CustomMessage.fromJson(list[i].data()).read, false, ['', widget.userData2['uid']]);
                              }
                            }
                            Navigator.pop(context);
                          },
                          child: const Text('Delete for me'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Cancel'),
                        ),
                      ],
                    );
                  });
                },
                icon: const Icon(Icons.delete),
                iconSize: 20.0,
              ),

              GestureDetector(
                onTap: () {},
                child: Container(
                  padding: const EdgeInsets.only(top: 5),
                  //height: 20,
                  width: 20,
                  child: Image.asset('assets/forward.png', color: Colors.white),
                ),
              ),

              IconButton(
                onPressed: () {},
                iconSize: 20.0,
                icon: const Icon(Icons.more_vert),
              )
            ],
          );

          final AppBar appBar1 = AppBar(
            flexibleSpace: SafeArea(
              child: Container(
                margin: const EdgeInsets.only(left: 45, top: 8),
                child: Row(
                  children: [
                    // IconButton(
                    //   icon: const Icon(Icons.arrow_back),
                    //   iconSize: 20.0,
                    //   onPressed: () {
                    //     Navigator.pop(context);
                    //   },
                    // ),
                    const SizedBox(
                      width: 2,
                    ),
                    CircleAvatar(
                      radius: 20.0,
                      backgroundImage: widget.userData2['image'] != ''
                      ? maleAvatars.contains(widget.userData2['image']) || femaleAvatars.contains(widget.userData2['image']) ? AssetImage(widget.userData2['image'].toString()) : Image.file(File(widget.userData2['image'])).image
                      : const AssetImage('assets/avatar.png'),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      widget.userData2['name'],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              IconButton(
                onPressed: () {},
                iconSize: 20.0,
                icon: const Icon(Icons.more_vert),
              )
            ],
          );

          return Scaffold(
            backgroundColor: Colors.white,
            appBar: selected > 0 ? appBar2 : appBar1,
            body: Stack(
              children: [
                Container(
                  padding: const EdgeInsets.only(bottom: 75),
                  child: ListView.builder(
                    reverse: isReverse,
                    controller: _scrollController,
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      if (CustomMessage.fromJson(list[list.length - index - 1].data()).visibleTo.contains(widget.userData1.uid)) {
                        return MessageCard(userData1: widget.userData1, userData2: widget.userData2, message: CustomMessage.fromJson(list[list.length - index - 1].data()), selected: selected);
                      }
                      else {
                        return const SizedBox.shrink();
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
                        IconButton(
                          onPressed: getImageFromCamera,
                          icon: const Icon(Icons.camera_alt, size: 25.0),
                        ),
                        FloatingActionButton.small(
                          onPressed: () async {

                            time = DateTime.now();
                            //case 1: the list is empty and this is the first message of the conversation (we have to add current user to the chat list of the other user and then send the message)
                            final chatList = await DatabaseService(uid: widget.userData1.uid).obtainChatList(widget.userData2['uid']);
                            await DatabaseService(uid: widget.userData1.uid, uid2: widget.userData2['uid']).sendFirstMessage(widget.userData1, chatList, _controller.text, time);
                            //case 2: the list is not empty
                            await DatabaseService(uid: widget.userData1.uid, uid2: widget.userData2['uid']).sendMessage(_controller.text, time, '', '', '');

                            setState(() {
                              //isReverse = false;
                              _scrollController.animateTo(_scrollController.position.minScrollExtent, duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
                              _controller.clear();
                            });
                          },
                          child: const Icon(Icons.send, size: 20.0),
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
