import 'dart:io';
import 'package:igsaver/services/instagram_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:igsaver/constants.dart';
import 'package:igsaver/pages/settings.dart';

class Home extends StatefulWidget {
  static const route = '/';

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  InstagramDownloader instagramDownloader = InstagramDownloader();
  String? url;

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
                        child: TextField(
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide:
                                  BorderSide(color: kPrimaryColor, width: 1.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide:
                                  BorderSide(color: kPrimaryColor, width: 2.0),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            hintText: 'Paste Link Here',
                            isDense: true,
                          ),
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
                          instagramDownloader.getPost(url ?? '');
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
                      OutlinedButton(
                        child: Text(
                          'Profile Download',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          backgroundColor: kPrimaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          side: BorderSide(color: kPrimaryColor),
                        ),
                        onPressed: () {},
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
}
