import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:igsaver/constants.dart';
import 'package:igsaver/exceptions.dart';

import 'package:igsaver/pages/history.dart';
import 'package:igsaver/pages/profile_download.dart';
import 'package:igsaver/pages/settings.dart';

import 'package:igsaver/services/instagram_downloader.dart';

import 'package:igsaver/mixins/initialize.dart';

import 'package:igsaver/widgets/rounded_dialog.dart';
import 'package:igsaver/widgets/rounded_textfield.dart';
import 'package:igsaver/widgets/rounded_button.dart';
import 'package:igsaver/widgets/error_dialog.dart';

class Home extends StatefulWidget {
  static const route = '/';

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home>
    with SingleTickerProviderStateMixin, InitializeMixin {
  var igPostDownloader = InstagramPostDownloader();
  var igProfileDownloader = InstagramProfileDownloader();
  var _flex = 1.0;
  var username = '';
  String? url;

  void _startupAnimation() {
    var controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 600),
      lowerBound: 1.0,
      upperBound: 3000.0,
    );
    Animation<double> animation = CurvedAnimation(
      parent: controller,
      curve: Curves.easeOut,
    );
    animation.addListener(() {
      // print(controller.value);
      setState(() {
        _flex = controller.value;
      });
    });
    controller.forward();
  }

  Future<void> _showUsernameInputDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        var localization = AppLocalizations.of(context)!;

        return RoundedDialog(
          title: Text(localization.downloadProfilePosts),
          children: <Widget>[
            RoundedTextField(
              hint: localization.usernameInputHint,
              keyboardType: TextInputType.text,
              onChanged: (value) {
                username = value;
              },
            ),
            SizedBox(height: 15),
            FilledRoundedButton(
              text: localization.search,
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
                      title: localization.userNotFound,
                      message: '',
                    );
                  } on SocketException {
                    ErrorDialog.show(
                      context,
                      title: localization.noInternetConnection,
                      message: localization.noInternetConnectionMessage,
                    );
                  } catch (_) {
                    ErrorDialog.show(
                      context,
                      title: localization.unknownError,
                      message: localization.unknownErrorMessage,
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
  void initState() {
    super.initState();
    initialize(context, _startupAnimation);
  }

  @override
  Widget build(BuildContext context) {
    var localization = AppLocalizations.of(context)!;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: kPrimaryColor,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              flex: 5000 - _flex.toInt(),
              child: Center(
                child: Text(
                  'IGSaver',
                  style: TextStyle(
                    fontSize: 75,
                    color: Colors.white,
                    fontFamily: 'FreeScript',
                  ),
                ),
              ),
            ),
            Expanded(
              flex: _flex.toInt(),
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
                            hint: localization.pasteLinkHere,
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
                                title: localization.invalidURL,
                                message: localization.invalidURLMessage,
                              );
                            } on PostNotFoundException {
                              ErrorDialog.show(
                                context,
                                title: localization.postNotFound,
                                message: localization.postNotFoundMessage,
                              );
                            } on SocketException {
                              ErrorDialog.show(
                                context,
                                title: localization.noInternetConnection,
                                message:
                                    localization.noInternetConnectionMessage,
                              );
                            } catch (_) {
                              ErrorDialog.show(
                                context,
                                title: localization.unknownError,
                                message: localization.unknownErrorMessage,
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
                          tooltip: localization.history,
                        ),
                        FilledRoundedButton(
                          text: localization.downloadProfile,
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
                          tooltip: localization.settings,
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
}
