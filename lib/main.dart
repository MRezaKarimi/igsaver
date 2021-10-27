import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:igsaver/pages/image_viewer.dart';
import 'package:igsaver/pages/select_post.dart';
import 'package:igsaver/pages/history.dart';
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
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      builder: (context, navigator) {
        /// Set Vazir as default font family when device language is 'fa'.
        /// Otherwise, don't change it.
        var lang = Localizations.localeOf(context).languageCode;
        if (lang == 'fa') {
          return Theme(
            data: ThemeData(fontFamily: 'Vazir'),
            child: navigator!,
          );
        } else {
          return navigator!;
        }
      },
    );
  }
}
