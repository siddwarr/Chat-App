import 'package:chat_app/models/custom_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants.dart';
import '../services/auth.dart';
import '../services/database.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  final AuthService _authService = AuthService();

  final CollectionReference collectionReference = FirebaseFirestore.instance.collection('users_collection');

  //form values
  String currentName = '';
  String currentPassword = '';
  String currentUsername = '';
  String error = '';
  bool showPassword = false;
  IconData passwordIcon = Icons.remove_red_eye;
  bool loading = false;

  final _formKey = GlobalKey<FormState>(); //to validate our form

  Map data = {};

  @override
  Widget build(BuildContext context) {

    //receiving the arguments from the home screen
    data = ModalRoute.of(context)!.settings.arguments as Map;

    // currentName = data['name'];
    // currentPassword = data['password'];
    // currentUsername = data['username'];

    //username validation (checking if username currently entered by user coincides with any other username
    Future<bool> validateUsername(String username) async {
      final result = await collectionReference.where('username', isEqualTo: username).get();
      return result.docs.isNotEmpty;
    }

    changePassword(String oldPassword, String newPassword) async {
      final user = FirebaseAuth.instance.currentUser;
      var credentials = EmailAuthProvider.credential(email: data['email'], password: oldPassword);

      await user!.reauthenticateWithCredential(credentials).then((value) {
        return user.updatePassword(newPassword);
      }).catchError((error) {
        print(error.toString());
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile'
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: Form(
          key: _formKey, //associating _formKey with our Form widget
          child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: Column(
              children: [
                Column(
                  children: [
                    const CircleAvatar(
                      radius: 35.0,
                      child: Icon(Icons.person),
                    ),
                    TextButton(
                      onPressed: () {

                      },
                      child: const Text('Update Profile Picture'),
                    )
                  ],
                ),
                //for name
                TextFormField(
                  initialValue: data['name'],
                  decoration: textInputDecoration.copyWith(hintText: 'Name'),
                  validator: (val) => val!.isEmpty ? 'Please enter a name' : null,
                  onChanged: (val) => setState(() {
                    currentName = val;
                  }),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                //for username
                TextFormField(
                  initialValue: data['username'],
                  decoration: textInputDecoration.copyWith(hintText: 'Username'),
                  validator: (val) => val!.isEmpty ? 'Please enter a username' : null,
                  onChanged: (val) => setState(() {
                    currentUsername = val;
                  }),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                //for password
                TextFormField(
                  initialValue: data['password'],
                  decoration: textInputDecoration.copyWith(hintText: 'Password', suffixIcon: TextButton.icon(icon: Icon(passwordIcon), onPressed: () {
                    //here, we change the state of obscureText
                    setState(() {
                      showPassword = !showPassword;
                      if (passwordIcon == Icons.remove_red_eye) {
                        passwordIcon = Icons.remove_red_eye_outlined;
                      }
                      else {
                        passwordIcon = Icons.remove_red_eye;
                      }
                    });
                  }, label: const Text(''))),
                  validator: (val) => val!.length < 6 ? 'Password should contain at least 6 characters' : null, //we are validating the password by making sure it is at least 6 characters long
                  obscureText: !showPassword,
                  onChanged: (val) => setState(() {
                    currentPassword = val;
                  }),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                //save changes button
                ElevatedButton(
                  onPressed: () async {
                    //here we have to update the document corresponding to the current user's uid
                    if (_formKey.currentState!.validate()) { //validation
                      //if everything is valid, check for validity of the username and proceed to save changes

                      bool valid = false;

                      if (currentName == '') {
                        setState(() {
                          currentName = data['name'];
                        });
                      }
                      if (currentUsername == '') {
                        setState(() {
                          currentUsername = data['username'];
                        });
                      }
                      else {
                        //validate the username if the user has modified it in the text-field
                        valid = await validateUsername(currentUsername);
                      }
                      if (currentPassword == '') {
                        setState(() {
                          currentPassword = data['password'];
                        });
                      }
                      else {
                        await changePassword(data['password'], currentPassword);
                      }

                      if (!valid) {
                        await DatabaseService(uid: data['uid']).updateUserData(data['email'], currentPassword, currentName, currentUsername);
                        Navigator.pop(context);
                      }
                      else {
                        error = 'Username taken, please enter again';
                      }
                    }
                  },
                  child: const Text(
                    'Save Changes',
                  ),
                ),
                const SizedBox(
                  height: 8.0,
                ),
                //displaying the error message
                Text(
                  error,
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 14.0,
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                //logout button
                SizedBox(
                  width: 110.0,
                  child: ElevatedButton(
                    onPressed: () async {
                      await _authService.signOut();
                      Navigator.pop(context);
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Logout',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(
                          width: 5.0,
                        ),
                        Icon(Icons.logout),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
