import 'package:flutter/services.dart' hide Clipboard;
import 'package:flutter/widgets.dart';
import 'package:igsaver/exceptions/exceptions.dart';
import 'package:igsaver/pages/profile_download.dart';
import 'package:igsaver/services/clipboard.dart';
import 'package:igsaver/services/instagram_downloader.dart';
import 'package:igsaver/constants.dart';
import 'package:igsaver/pages/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:igsaver/widgets/rounded_textfield.dart';
import 'package:igsaver/widgets/rounded_button.dart';

class Home extends StatefulWidget {
  static const route = '/';

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  InstagramDownloader igDownloader = InstagramDownloader();
  InstagramProfileDownloader igProfileDownloader = InstagramProfileDownloader();
  Clipboard clipboard = Clipboard();
  String? url;
  String username = '';

  void watchClipboard() async {
    await for (var data in clipboard.getClipboardData()) {
      igDownloader.downloadPost(data);
    }
  }

  @override
  void initState() {
    super.initState();
    watchClipboard();
  }

  Future<void> _showDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          title: Text('Download Profile Posts'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                RoundedTextField(
                  hint: 'username',
                  keyboardType: TextInputType.text,
                  onChanged: (value) {
                    username = value;
                  },
                ),
                SizedBox(height: 15),
                RoundedButton(
                  text: 'Search',
                  onPressed: () async {
                    if (username != '') {
                      return;
                    }

                    try {
                      Map userInfo =
                          await igProfileDownloader.getUserInfo(username);

                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        ProfileDownload.route,
                        ModalRoute.withName(Home.route),
                        arguments: {'userInfo': userInfo},
                      );
                    } on PrivateAccountException catch (e) {
                      print('private account');
                    } on AccountHaveNoPostException catch (e) {
                      print('no post account');
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: kPrimaryColor,
      body: Column(
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
                        onPressed: () {
                          igDownloader.downloadPost(url ?? '');
                        },
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: Icon(
                          CupertinoIcons.clock,
                          color: kPrimaryColor,
                          size: 30,
                        ),
                      ),
                      RoundedButton(
                        text: 'Download Profile',
                        onPressed: () {
                          _showDialog();
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
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    clipboard.stop();
    super.dispose();
  }
}
