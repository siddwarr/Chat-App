import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/custom_user.dart';

class SettingsScreen extends StatefulWidget {

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
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
