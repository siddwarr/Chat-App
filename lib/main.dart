<<<<<<< HEAD
import 'package:chat_app/bottom_navigation_screens/home.dart';
import 'package:chat_app/bottom_navigation_screens/profile_page.dart';
import 'package:chat_app/bottom_navigation_screens/home.dart';
=======
import 'package:chat_app/screens/home.dart';
import 'package:chat_app/screens/profile_page.dart';
>>>>>>> upstream/main
import 'package:chat_app/services/auth.dart';
import 'package:chat_app/wrapper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/custom_user.dart';

import 'models/custom_user.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    //wrapping MaterialApp widget (root widget) with StreamProvider widget which will listen to changes in the stream between our flutter app and Firebase Authentication Service
    //StreamProvider.value - listens to value and expose it to all of StreamProvider descendants
    return StreamProvider<UserUID?>.value(
      initialData: null,
      catchError: (_,__) {
        return null;
      },
      value: AuthService().user,
      child: MaterialApp(
        initialRoute: '/',
        routes: {
          '/': (context) => const Wrapper(), //represents the first widget to be built when the app is first opened (when initialRoute not mentioned)
<<<<<<< HEAD
=======
          '/profile': (context) => const Profile(),
          '/home': (context) => const Home(),
>>>>>>> upstream/main
        },
      ),
    );
  }
}