import 'package:flutter/material.dart';
import 'package:igsaver/pages/image_viewer.dart';
import 'package:igsaver/pages/post_picker.dart';
import 'package:provider/provider.dart';
import 'package:igsaver/pages/history.dart';
import 'package:igsaver/pages/loading.dart';
import 'package:igsaver/pages/profile_download.dart';
import 'package:igsaver/pages/settings.dart';
import 'package:igsaver/pages/home.dart';
import 'package:igsaver/models/download_history.dart';

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
        ImageViewer.route: (context) => ImageViewer(),
        SelectPost.route: (context) => SelectPost(),
      },
    );
  }
}
