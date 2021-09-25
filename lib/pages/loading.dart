import 'dart:io';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:igsaver/constants.dart';
import 'package:igsaver/pages/home.dart';
import 'package:igsaver/services/settings_service.dart';
import 'package:igsaver/widgets/error_dialog.dart';

/// Shows a loading screen to the user and does initial staffs behind the scene.
class Loading extends StatelessWidget {
  static const String route = '/';

  /// Checks whether device is connected to the network or not.
  ///
  /// If device has network connection, returns true.
  /// Otherwise shows an error dialog and returns false.
  Future<bool> _checkNetworkConnection(BuildContext context) async {
    bool isConnected;
    await Future.delayed(Duration(seconds: 1));

    try {
      final result = await InternetAddress.lookup('google.com');
      isConnected = result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException {
      isConnected = false;
    }

    if (isConnected) {
      return true;
    } else {
      ErrorDialog.show(
        context,
        title: 'No Internet Connection',
        message:
            'Make sure your device is connected to the network and then try again.',
      );
      return false;
    }
  }

  /// Checks whether the app has external storage read/write permission or not.
  ///
  /// If permission is granted, returns true.
  /// Otherwise requests for permission. If permission denied again,
  /// it shows an error dialog returns false.
  Future<bool> _checkStoragePermission(BuildContext context) async {
    if (await Permission.manageExternalStorage.isGranted) {
      return true;
    } else {
      var status = await Permission.manageExternalStorage.request();
      if (status == PermissionStatus.granted) {
        return true;
      } else {
        ErrorDialog.show(
          context,
          title: 'Storage Permission Denied',
          message:
              'This app needs storage access permission to work. Go to your device\'s settings and grant permission',
        );

        return false;
      }
    }
  }

  /// Calls [_checkNetworkConnection] and [_checkStoragePermission].
  /// If both returned true,
  /// then [Home] page will be pushed to navigator
  void _initialStuffs(BuildContext context) async {
    await SettingsService.initialize();
    bool isConnected = await _checkNetworkConnection(context);
    bool hasPermission = await _checkStoragePermission(context);

    if (isConnected && hasPermission) {
      Navigator.pushReplacementNamed(context, Home.route);
    }
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
