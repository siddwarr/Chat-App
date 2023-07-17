import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/custom_user.dart';

class Settings extends StatefulWidget {

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {

    final userData = Provider.of<CustomUser?>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Settings',
        ),
      ),
    );
  }
}
