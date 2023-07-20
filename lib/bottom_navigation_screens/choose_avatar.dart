import 'package:flutter/material.dart';

class ChooseAvatar extends StatefulWidget {
  const ChooseAvatar({Key? key}) : super(key: key);

  @override
  State<ChooseAvatar> createState() => _ChooseAvatarState();
}

class _ChooseAvatarState extends State<ChooseAvatar> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose Avatar'),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 10,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 45.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            //do what you want here
                          },
                          child: const CircleAvatar(
                            radius: 60.0,
                            backgroundImage: AssetImage('assets/male_avatars/male1.jpg'),
                          ),
                        ),
                        const SizedBox(
                          width: 80.0,
                        ),
                        GestureDetector(
                          onTap: () {
                            //do what you want here
                          },
                          child: const CircleAvatar(
                            radius: 60.0,
                            backgroundImage: AssetImage('assets/female_avatars/female1.jpg'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            //do what you want here
                          },
                          child: const CircleAvatar(
                            radius: 60.0,
                            backgroundImage: AssetImage('assets/male_avatars/male2.jpg'),
                          ),
                        ),
                        const SizedBox(
                          width: 80.0,
                        ),
                        GestureDetector(
                          onTap: () {
                            //do what you want here
                          },
                          child: const CircleAvatar(
                            radius: 60.0,
                            backgroundImage: AssetImage('assets/female_avatars/female2.jpg'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            //do what you want here
                          },
                          child: const CircleAvatar(
                            radius: 60.0,
                            backgroundImage: AssetImage('assets/male_avatars/male3.jpg'),
                          ),
                        ),
                        const SizedBox(
                          width: 80.0,
                        ),
                        GestureDetector(
                          onTap: () {
                            //do what you want here
                          },
                          child: const CircleAvatar(
                            radius: 60.0,
                            backgroundImage: AssetImage('assets/female_avatars/female3.jpg'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            //do what you want here
                          },
                          child: const CircleAvatar(
                            radius: 60.0,
                            backgroundImage: AssetImage('assets/male_avatars/male4.jpg'),
                          ),
                        ),
                        const SizedBox(
                          width: 80.0,
                        ),
                        GestureDetector(
                          onTap: () {
                            //do what you want here
                          },
                          child: const CircleAvatar(
                            radius: 60.0,
                            backgroundImage: AssetImage('assets/female_avatars/female4.jpg'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            //do what you want here
                          },
                          child: const CircleAvatar(
                            radius: 60.0,
                            backgroundImage: AssetImage('assets/male_avatars/male5.jpg'),
                          ),
                        ),
                        const SizedBox(
                          width: 80.0,
                        ),
                        GestureDetector(
                          onTap: () {
                            //do what you want here
                          },
                          child: const CircleAvatar(
                            radius: 60.0,
                            backgroundImage: AssetImage('assets/female_avatars/female5.jpg'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            //do what you want here
                          },
                          child: const CircleAvatar(
                            radius: 60.0,
                            backgroundImage: AssetImage('assets/male_avatars/male6.jpg'),
                          ),
                        ),
                        const SizedBox(
                          width: 80.0,
                        ),
                        GestureDetector(
                          onTap: () {
                            //do what you want here
                          },
                          child: const CircleAvatar(
                            radius: 60.0,
                            backgroundImage: AssetImage('assets/female_avatars/female6.jpg'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            //do what you want here
                          },
                          child: const CircleAvatar(
                            radius: 60.0,
                            backgroundImage: AssetImage('assets/male_avatars/male7.jpg'),
                          ),
                        ),
                        const SizedBox(
                          width: 80.0,
                        ),
                        GestureDetector(
                          onTap: () {
                            //do what you want here
                          },
                          child: const CircleAvatar(
                            radius: 60.0,
                            backgroundImage: AssetImage('assets/female_avatars/female7.jpg'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(onPressed: () {}, child: const Text('Select'))
            ),
          )
        ],
      ),
    );
  }
}
