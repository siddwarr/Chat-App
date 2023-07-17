import 'package:chat_app/models/custom_user.dart';
import 'package:chat_app/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants.dart';
import '../services/auth.dart';
import 'loading.dart';

class SignIn extends StatefulWidget {
  //accepting the toggleView function in the constructor as a parameter from authenticate.dart
  final Function toggleView;
  SignIn({required this.toggleView});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  //creating an instance of the AuthService class that we had created in auth.dart file
  final AuthService _authService = AuthService();

  String email = '';
  String password = '';
  String error = '';
  bool showPassword = false;
  IconData passwordIcon = Icons.remove_red_eye;

  final _formKey = GlobalKey<FormState>(); //to validate our form (username and password)

  bool loading = false;

  @override
  Widget build(BuildContext context) {

    if (loading) {
      return const Loading();
    }
    else {
      return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Sign In',
          ),
          actions: [
            TextButton.icon(
              onPressed: () {
                //whenever we click on the Register button on the top right, we call the toggle view function
                //this function toggles the value of showSignIn => we switch to the Register screen
                widget.toggleView();
              },
              icon: const Icon(Icons.person, color: Colors.white),
              label: const Text('Register', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
          child: Form(
            key: _formKey, //associating _formKey with our Form widget
            child: Column(
              children: [
                const SizedBox(
                  height: 20.0,
                ),
                //for username/email-id
                TextFormField(
                  //val represents whatever remains in the form field at a particular time
                  //this function will run whenever the user changes the contents of the form field (by entering new character or entering backspace)
                  validator: (val) => val!.isEmpty ? 'Enter an email' : null, //we are validating the email by making sure it is not empty
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
                  obscureText: !showPassword,
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
                ElevatedButton(
                  child: const Text(
                    'Sign In',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () async {
                    //here is where we need to interact with Firebase and sign the user up with the entered email and password
                    if (_formKey.currentState!.validate()) { //for the user to sign in successfully, validators from both TextFormFields should return 'null'
                      setState(() {
                        loading = true;
                      });
                      dynamic result = await _authService.signInWithEmailPassword(email, password);
                      if (result == null) {
                        setState(() {
                          error = 'Could not sign-in with those credentials';
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
      );
    }
  }
}