import 'package:chat_app/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../constants.dart';
import '../services/auth.dart';
import 'loading.dart';

class Register extends StatefulWidget {
  //accepting the toggleView function in the constructor as a parameter from authenticate.dart
  final Function toggleView;
  Register({required this.toggleView});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  final CollectionReference collectionReference = FirebaseFirestore.instance.collection('users_collection');

  //creating an instance of the AuthService class that we had created in auth.dart file
  final AuthService _authService = AuthService();

  String email = '';
  String password = '';
  String name = '';
  String username = '';
  String error = '';
  bool showPassword = false;
  IconData passwordIcon = Icons.remove_red_eye;

  final _formKey = GlobalKey<FormState>(); //to validate our form (username and password)

  bool loading = false;

  @override
  Widget build(BuildContext context) {

    //username validation (checking if username currently entered by user coincides with any other username
    Future<bool> validateUsername(String username) async {
      final result = await collectionReference.where('username', isEqualTo: username).get();
      return result.docs.isNotEmpty;
    }

    if (loading) {
      return const Loading();
    }
    else {
      return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Register',
        ),
        actions: [
          TextButton.icon(
              onPressed: () {
                //whenever we click on the Register button on the top right, we call the toggle view function
                //this function toggles the value of showSignIn => we switch to the Register screen
                widget.toggleView();
              },
              icon: const Icon(Icons.person, color: Colors.white),
              label: const Text('Sign In', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: Form(
          key: _formKey, //associating _formKey with our Form widget
          child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: Column(
              children: [
                const SizedBox(
                  height: 20.0,
                ),
                //for username/email-id
                TextFormField(
                  //val represents whatever remains in the form field at a particular time
                  //this function will run whenever the user changes the contents of the form field (by entering new character or entering backspace)
                  validator: (val) => val!.isEmpty ? 'Enter a valid email' : null, //we are validating the email by making sure it is not empty
                  decoration: textInputDecoration.copyWith(hintText: 'Email'),
                  onChanged: (val) {
                    setState(() {
                      //updating the 'email'
                      email = val;
                    });
                  },
                ),
                const SizedBox(
                  height: 20.0,
                ),
                //for password
                TextFormField(
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
                  obscureText: true,
                  onChanged: (val) {
                    setState(() {
                      //updating the 'password'
                      password = val;
                    });
                  },
                ),
                const SizedBox(
                  height: 20.0,
                ),
                //for name
                TextFormField(
                  decoration: textInputDecoration.copyWith(hintText: 'Name'),
                  validator: (val) => val!.isEmpty ? 'Enter a valid name' : null,
                  onChanged: (val) {
                    setState(() {
                      //updating the 'name'
                      name = val;
                    });
                  },
                ),
                const SizedBox(
                  height: 20.0,
                ),
                //for username
                TextFormField(
                  decoration: textInputDecoration.copyWith(hintText: 'Username'),
                  validator: (val) => val!.isEmpty ? 'Enter a valid username' : null,
                  onChanged: (val) {
                    setState(() {
                      //updating the 'username'
                      username = val;
                    });
                  },
                ),
                const SizedBox(
                  height: 10.0,
                ),
                ElevatedButton(
                  child: const Text(
                    'Register',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () async {
                    //here is where we need to interact with Firebase and sign the user up with the entered email and password
                    if (_formKey.currentState!.validate()) { //for the user to register successfully, validators from both TextFormFields should return 'null'
                      //if everything is valid, check for validity of the username and proceed to register
                      final valid = await validateUsername(username);
                      if (!valid) {
                        setState(() {
                          loading = true;
                        });
                        dynamic result = await _authService.registerWithEmailPassword(email, password, name, username);
                        if (result == null) {
                          setState(() {
                            error = 'Could not register with those credentials';
                            loading = false;
                          });
                        }
                      }
                      else {
                        setState(() {
                          error = 'Username taken, please enter again';
                          loading = false;
                        });
                      }
                    }
                  },
                ),
                const SizedBox(
                  height: 12.0,
                ),
                //displaying the error message (if the user could not register successfully)
                Text(
                  error,
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 14.0,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    };
  }
}
