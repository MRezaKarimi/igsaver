import 'package:flutter/material.dart';
import 'package:igsaver/pages/image_viewer.dart';
import 'package:igsaver/pages/select_post.dart';
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
      initialRoute: '/',
      routes: {
        Home.route: (context) => Home(),
        Settings.route: (context) => Settings(),
        History.route: (context) => History(),
        ProfileDownload.route: (context) => ProfileDownload(),
        ImageViewer.route: (context) => ImageViewer(),
        SelectPost.route: (context) => SelectPost(),
      },
    );
  }
}
