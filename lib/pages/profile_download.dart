import 'package:flutter/material.dart';
import 'package:igsaver/constants.dart';
import 'package:igsaver/widgets/rounded_button.dart';
import 'package:igsaver/widgets/rounded_textfield.dart';
import 'package:igsaver/widgets/settings_card.dart';

class ProfileDownload extends StatefulWidget {
  static const route = '/profile_download';
  // final Map userInfo;

  // ProfileDownload(this.userInfo);

  @override
  _ProfileDownloadState createState() => _ProfileDownloadState();
}

class _ProfileDownloadState extends State<ProfileDownload> {
  bool onlyImagesSwitch = true;
  bool downloadAllSwitch = true;
  int numberOfPosts = 0;

  @override
  Widget build(BuildContext context) {
    Map args = ModalRoute.of(context)!.settings.arguments as Map;
    Map userInfo = args['userInfo'];

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        elevation: 0,
        title: Text('Download Profile'),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 3,
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      CircleAvatar(
                        radius: 30,
                        backgroundImage:
                            NetworkImage(userInfo['profilePicUrl']),
                      ),
                      SizedBox(width: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            userInfo['name'],
                            style: TextStyle(fontSize: 20),
                          ),
                          Text(
                            '@${userInfo['username']}',
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 15,
                            ),
                          ),
                          Text(
                            '${userInfo['postCount']} Posts',
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 15,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 15),
                    child: Divider(
                      // height: 10,
                      thickness: 1,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 7,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Only Download Images',
                        style: TextStyle(fontSize: 17),
                      ),
                      Switch(
                        value: onlyImagesSwitch,
                        activeColor: kPrimaryColor,
                        activeTrackColor: kPrimaryShadowColor,
                        onChanged: (value) {
                          setState(() {
                            onlyImagesSwitch = value;
                          });
                        },
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Download All Posts',
                        style: TextStyle(fontSize: 17),
                      ),
                      Switch(
                        value: downloadAllSwitch,
                        activeColor: kPrimaryColor,
                        activeTrackColor: kPrimaryShadowColor,
                        onChanged: (value) {
                          setState(() {
                            downloadAllSwitch = value;
                          });
                        },
                      ),
                    ],
                  ),
                  Visibility(
                    visible: !downloadAllSwitch,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 15, bottom: 20),
                          child: Text(
                            'Download First $numberOfPosts Posts',
                            style: TextStyle(
                              fontSize: 17,
                              color: kPrimaryColor,
                            ),
                          ),
                        ),
                        SliderTheme(
                          data: SliderThemeData(
                            inactiveTickMarkColor: Colors.transparent,
                            activeTickMarkColor: Colors.transparent,
                            inactiveTrackColor: kPrimaryShadowColor,
                            activeTrackColor: kPrimaryColor,
                            thumbColor: kPrimaryColor,
                            overlayShape:
                                RoundSliderOverlayShape(overlayRadius: 0),
                          ),
                          child: Slider(
                            value: numberOfPosts.toDouble(),
                            min: 0,
                            max: 50,
                            divisions: 10,
                            // label: numberOfPosts.toString(),
                            onChanged: (double value) {
                              setState(() {
                                numberOfPosts = value.toInt();
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: RoundedButton(text: 'Start Download', onPressed: () {}),
            ),
          ],
        ),
      ),
    );
  }
}
