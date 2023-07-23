import 'package:flutter/material.dart';

class ChooseAvatar extends StatefulWidget {
  const ChooseAvatar({Key? key}) : super(key: key);

  @override
  State<ChooseAvatar> createState() => _ChooseAvatarState();
}

class _ChooseAvatarState extends State<ChooseAvatar> {

  bool isSelected = false;
  String selectedAvatar = '';

  List maleAvatars = ['male_avatars/male1.jpg', 'male_avatars/male2.jpg', 'male_avatars/male3.jpg', 'male_avatars/male4.jpg', 'male_avatars/male5.jpg', 'male_avatars/male6.jpg', 'male_avatars/male7.jpg'];
  List femaleAvatars = ['female_avatars/female1.jpg', 'female_avatars/female2.jpg', 'female_avatars/female3.jpg', 'female_avatars/female4.jpg', 'female_avatars/female5.jpg', 'female_avatars/female6.jpg', 'female_avatars/female7.jpg'];

  @override
  Widget build(BuildContext context) {

    bool isHighlighted(String currentAvatar, String selectedAvatar) {
      if (isSelected == true && currentAvatar == selectedAvatar) {
        return false;
      }
      return true;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose Avatar'),
      ),
      body: Column(
        children: [
          SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            child: Container(
              height: 590,
              padding: const EdgeInsets.fromLTRB(45, 20, 45, 5),
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                children: [
                  for (int i = 0; i < 7; i++)
                  Column(
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                if (!('assets/${maleAvatars[i]}' != selectedAvatar && isSelected)) {
                                  isSelected = !isSelected;
                                }
                                selectedAvatar = 'assets/${maleAvatars[i]}';
                              });
                            },
                            child: CircleAvatar(
                              radius: 60.0,
                              backgroundColor: isHighlighted('assets/${maleAvatars[i]}', selectedAvatar) ? Colors.white : Colors.green,
                              child: CircleAvatar(
                                radius: 55,
                                backgroundImage: AssetImage('assets/${maleAvatars[i]}'),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 80.0,
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                if (!('assets/${femaleAvatars[i]}' != selectedAvatar && isSelected)) {
                                  isSelected = !isSelected;
                                }
                                selectedAvatar = 'assets/${femaleAvatars[i]}';
                              });
                            },
                            child: CircleAvatar(
                              radius: 60.0,
                              backgroundColor: isHighlighted('assets/${femaleAvatars[i]}', selectedAvatar) ? Colors.white : Colors.green,
                              child: CircleAvatar(
                                radius: 55,
                                backgroundImage: AssetImage('assets/${femaleAvatars[i]}'),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20.0,
                      )
                    ],
                  ),
                ]
              )
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.only(left: 5, right: 5, bottom: 5),
              width: double.infinity,
              height: 35,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context, selectedAvatar);
                },
                child: const Text('Select')
              )
            ),
          )
        ],
      ),
    );
  }
}
