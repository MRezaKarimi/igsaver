import 'dart:io';

import 'package:flutter/services.dart' hide Clipboard;
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:igsaver/constants.dart';
import 'package:igsaver/exceptions/exceptions.dart';

import 'package:igsaver/pages/history.dart';
import 'package:igsaver/pages/profile_download.dart';
import 'package:igsaver/pages/settings.dart';

import 'package:igsaver/services/clipboard_monitor.dart';
import 'package:igsaver/services/instagram_downloader.dart';

import 'package:igsaver/widgets/rounded_dialog.dart';
import 'package:igsaver/widgets/rounded_textfield.dart';
import 'package:igsaver/widgets/rounded_button.dart';
import 'package:igsaver/widgets/error_dialog.dart';

class Home extends StatefulWidget {
  static const route = '/home';

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var igPostDownloader = InstagramPostDownloader();
  var igProfileDownloader = InstagramProfileDownloader();
  var clipboardMonitor = ClipboardMonitor();

  String? url;
  var username = '';

  @override
  void initState() {
    super.initState();
    clipboardMonitor.start();
  }

  Future<void> _showUsernameInputDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return RoundedDialog(
          title: Text('Download Profile Posts'),
          children: <Widget>[
            RoundedTextField(
              hint: 'username without @',
              keyboardType: TextInputType.text,
              onChanged: (value) {
                username = value;
              },
            ),
            SizedBox(height: 15),
            FilledRoundedButton(
              text: 'Search',
              onPressed: () async {
                if (username != '') {
                  try {
                    var userInfo =
                        await igProfileDownloader.getUserInfo(username);

                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      ProfileDownload.route,
                      ModalRoute.withName(Home.route),
                      arguments: {'userInfo': userInfo},
                    );
                  } on UserNotFoundException {
                    ErrorDialog.show(
                      context,
                      title: 'User Not Found!',
                      message: '',
                    );
                  } on PrivateAccountException {
                    ErrorDialog.show(
                      context,
                      title: 'Oops! Account is private',
                      message: '',
                    );
                  } on AccountHasNoPostException {
                    ErrorDialog.show(
                      context,
                      title: 'Account has no post!',
                      message: '',
                    );
                  } on SocketException {
                    ErrorDialog.show(
                      context,
                      title: 'Connection Error!',
                      message:
                          'Check if your device have internet connection and try again.',
                    );
                  } catch (_) {
                    ErrorDialog.show(
                      context,
                      title: 'Oops! Something went wrong!',
                      message:
                          'Try again after a while or report problem to developer.',
                    );
                  }
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: kPrimaryColor,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Center(
                child: Text(
                  'IGSaver',
                  style: TextStyle(
                    fontSize: 40,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Container(
                padding:
                    EdgeInsets.only(left: 20, right: 20, top: 50, bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Expanded(
                          child: RoundedTextField(
                            hint: 'Paste Link Here',
                            keyboardType: TextInputType.url,
                            onChanged: (value) {
                              url = value;
                            },
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            CupertinoIcons.arrow_down_circle,
                            color: kPrimaryColor,
                            size: 35,
                          ),
                          onPressed: () async {
                            try {
                              await igPostDownloader.downloadPost(
                                  url ?? '', false);
                            } on InvalidUrlException {
                              ErrorDialog.show(
                                context,
                                title: 'Invalid URL!',
                                message:
                                    'The given URL is not a valid instagram URL.',
                              );
                            }
                          },
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.pushNamed(context, History.route);
                          },
                          icon: Icon(
                            CupertinoIcons.clock,
                            color: kPrimaryColor,
                            size: 30,
                          ),
                          tooltip: 'History',
                        ),
                        FilledRoundedButton(
                          text: 'Download Profile',
                          onPressed: () {
                            _showUsernameInputDialog();
                          },
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.pushNamed(context, Settings.route);
                          },
                          icon: Icon(
                            CupertinoIcons.settings,
                            color: kPrimaryColor,
                            size: 30,
                          ),
                          tooltip: 'Settings',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /*@override
  void dispose() {
    clipboard.stop();
    super.dispose();
  }*/
}
