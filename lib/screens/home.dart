import 'package:chat_app/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/custom_user.dart';
import '../services/auth.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  @override
  Widget build(BuildContext context) {

    final userUIDData = Provider.of<UserUID?>(context);

    return StreamBuilder<CustomUser?>(
      stream: DatabaseService(uid: userUIDData!.uid).userDataStream,
      builder: (context, snapshot) {

        CustomUser? userData = snapshot.data;

        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Home',
            ),
            //a list of widgets to display in a row after the title widget
            actions: [
              //circle avatar that redirects user to profile page
              TextButton.icon(
                icon: const Icon(Icons.person, color: Colors.white),
                onPressed: () {
                  //here we have to redirect the user to the profile page

                  Navigator.pushNamed(context, '/profile', arguments: {
                    'uid': userData?.uid,
                    'email': userData?.email,
                    'password': userData?.password,
                    'name': userData?.name,
                    'username': userData?.username,
                  });
                },
                label: const Text('Profile', style: TextStyle(fontSize: 15.0, color: Colors.white)),
              ),
            ],
          ),
          body: IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: CustomSearchDelegate());
            },
          ),
        );
      }
    );
  }
}

class CustomSearchDelegate extends SearchDelegate {
  @override
  List<Widget>? buildActions(BuildContext context) {
    // TODO: implement buildActions
    throw UnimplementedError();
  }

  @override
  Widget? buildLeading(BuildContext context) {
    // TODO: implement buildLeading
    throw UnimplementedError();
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    throw UnimplementedError();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions
    throw UnimplementedError();
  }

}
