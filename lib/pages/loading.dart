import 'dart:io';
import 'package:flutter/material.dart';
import 'package:igsaver/constants.dart';
import 'package:igsaver/pages/home.dart';
import 'package:igsaver/services/settings_service.dart';
import 'package:igsaver/widgets/rounded_dialog.dart';
import 'package:igsaver/widgets/error_dialog.dart';

class Loading extends StatelessWidget {
  static const String route = '/';

  Future<bool> _hasNetwork() async {
    Future.delayed(Duration(seconds: 1));
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException {
      return false;
    }
  }

  void _checkNetworkConnection(BuildContext context) async {
    bool isConnected = await _hasNetwork();
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

  @override
  Widget build(BuildContext context) {
    _checkNetworkConnection(context);
    SettingsService.initialize();
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
