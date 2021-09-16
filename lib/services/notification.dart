import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

class Notification {
  int _counter = 0;

  Notification() {
    AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
          channelKey: 'download_notification',
          channelName: 'Download Notification',
          channelDescription: 'Notification for downloads',
          defaultColor: Colors.white,
          importance: NotificationImportance.Low,
        )
      ],
    );
  }

  void show(String filename) {
    _counter++;

    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: _counter,
        channelKey: 'download_notification',
        title: 'Download Completed',
        body: filename,
        ticker: 'Download Completed',
        autoCancel: true,
      ),
    );
  }
}
