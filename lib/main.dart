import 'package:chat_app/models/custom_user.dart';
import 'package:chat_app/services/auth.dart';
import 'package:chat_app/wrapper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
      child: const MaterialApp(
        home: Wrapper(),
      ),
    );
  }
}
