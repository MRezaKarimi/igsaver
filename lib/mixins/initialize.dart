import 'dart:io';

import 'package:flutter/material.dart';
import 'package:igsaver/services/clipboard_monitor.dart';
import 'package:igsaver/services/file_downloader.dart';
import 'package:igsaver/services/settings_service.dart';
import 'package:igsaver/widgets/error_dialog.dart';
import 'package:permission_handler/permission_handler.dart';

typedef OnSuccess = void Function();

mixin InitializeMixin {
  /// Checks whether device is connected to the network or not.
  ///
  /// If device has network connection, returns true.
  /// Otherwise shows an error dialog and returns false.
  Future<bool> _checkNetworkConnection(BuildContext context) async {
    bool isConnected;

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
    if (await Permission.manageExternalStorage.isGranted ||
        await Permission.manageExternalStorage.isRestricted) {
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

  /// Initializes necessary services needed for app to working:
  /// - open settings box in HiveDB
  /// - check network connection
  /// - check/ask storage permission
  /// - create directories for saving images and videos
  void initialize(BuildContext context, OnSuccess onSuccess) async {
    await SettingsService.initialize();
    bool isConnected = await _checkNetworkConnection(context);
    bool hasPermission = await _checkStoragePermission(context);
    await FileDownloader.createDirectories();
    ClipboardMonitor.start();

    if (isConnected && hasPermission) {
      onSuccess();
    }
  }
}
