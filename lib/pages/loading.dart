import 'dart:io';
import 'package:flutter/material.dart';
import 'package:igsaver/constants.dart';
import 'package:igsaver/pages/home.dart';
import 'package:igsaver/services/settings_service.dart';
import 'package:igsaver/widgets/error_dialog.dart';

class Loading extends StatelessWidget {
  static const String route = '/';

  Future<void> _checkNetworkConnection(BuildContext context) async {
    bool isConnected;
    await Future.delayed(Duration(seconds: 1));

    try {
      final result = await InternetAddress.lookup('google.com');
      isConnected = result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException {
      isConnected = false;
    }

    if (isConnected) {
      Navigator.pushReplacementNamed(context, Home.route);
    } else {
      ErrorDialog.show(
        context,
        title: 'No Internet Connection',
        message:
            'Make sure your device is connected to the network and then try again.',
      );
    }
  }

  void _initialStuffs(BuildContext context) async {
    await SettingsService.initialize();
    await _checkNetworkConnection(context);
  }

  @override
  Widget build(BuildContext context) {
    _initialStuffs(context);
    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: Center(
        child: Text(
          'IGSaver',
          style: TextStyle(
            fontSize: 40,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
