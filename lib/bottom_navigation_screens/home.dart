import 'package:chat_app/bottom_navigation_screens/search_tile.dart';
import 'package:chat_app/screens/loading.dart';
import 'package:chat_app/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/custom_user.dart';
import 'chat_tile.dart';

class Home extends StatefulWidget {

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {

    final userData = Provider.of<CustomUser?>(context);

    final userChatList = Provider.of<List<CustomUser>>(context);

    if (userData == null) {
      return const Loading();
    }
    else {
      return StreamBuilder<List<CustomUser>?>(
        stream: DatabaseService(uid: userData.uid).userDataListStream,
        builder: (context, snapshot) {

          final userDataList = snapshot.data;

          return Scaffold(
            appBar: AppBar(
              title: const Text('Home'),
              actions: [
                IconButton(
                  onPressed: () {
                    showSearch(
                      context: context,
                      delegate: CustomSearchDelegate(userDataList: userDataList, userChatList: userChatList),
                    );
                  },
                  icon: const Icon(Icons.search),
                )
              ],
            ),
            body: ListView.builder(
              itemCount: userChatList.length,
              itemBuilder: (context, index) {
                return ChatTile(userData1: userData, userData2: userChatList[index]);
              }
            ),
          );
        }
      );
    }
  }
}

class CustomSearchDelegate extends SearchDelegate {

  List<CustomUser>? userDataList;

  List<CustomUser> userChatList;

  CustomSearchDelegate({this.userDataList, required this.userChatList});

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      //to clear the query
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.clear),
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null); //close the search bar
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List<CustomUser> matchQuery = [];
    for (CustomUser user in userDataList!) {
      if (user.username.contains(query)) {
        matchQuery.add(user);
      }
    }

    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        return SearchTile(userData: matchQuery[index], userChatList: userChatList);
      }
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<CustomUser> matchQuery = [];
    for (CustomUser user in userDataList!) {
      if (user.username.contains(query)) {
        matchQuery.add(user);
      }
    }

    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        return SearchTile(userData: matchQuery[index], userChatList: userChatList);
      }
    );
  }
}