import 'package:flutter/material.dart';
import 'package:igsaver/pages/history.dart';
import 'package:igsaver/pages/loading.dart';
import 'package:igsaver/pages/profile_download.dart';
import 'package:igsaver/pages/settings.dart';
import 'package:igsaver/pages/home.dart';

void main() {
  runApp(IGSaver());
}

class IGSaver extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IGSaver',
      initialRoute: Loading.route,
      routes: {
        Loading.route: (context) => Loading(),
        Home.route: (context) => Home(),
        Settings.route: (context) => Settings(),
        History.route: (context) => History(),
        ProfileDownload.route: (context) => ProfileDownload(),
      },
    );
  }
}
