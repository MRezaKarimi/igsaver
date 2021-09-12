import 'package:flutter/material.dart';
import 'package:igsaver/constants.dart';
import 'package:igsaver/pages/select_post.dart';
import 'package:igsaver/services/instagram_downloader.dart';
import 'package:igsaver/widgets/rounded_button.dart';

class ProfileDownload extends StatefulWidget {
  static const route = '/profile_download';

  @override
  _ProfileDownloadState createState() => _ProfileDownloadState();
}

class _ProfileDownloadState extends State<ProfileDownload> {
  InstagramProfileDownloader igProfileDownloader = InstagramProfileDownloader();
  bool imagesOnlySwitch = true;
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
                        value: imagesOnlySwitch,
                        activeColor: kPrimaryColor,
                        activeTrackColor: kPrimaryShadowColor,
                        onChanged: (value) {
                          setState(() {
                            imagesOnlySwitch = value;
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
                            max: userInfo['postCount'] <= 50
                                ? userInfo['postCount'] +
                                    .0 //Cast int to double
                                : 50,
                            // divisions: userInfo['count'] <= 50 ? userInfo['count']/,
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  RoundedButton(
                    text: 'Select Posts',
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        SelectPost.route,
                        arguments: {
                          'userID': userInfo['id'],
                        },
                      );
                    },
                  ),
                  FilledRoundedButton(
                    text: 'Download All',
                    onPressed: () {
                      if (downloadAllSwitch) {
                        igProfileDownloader.downloadProfile(
                            int.parse(userInfo['id']), numberOfPosts, true,
                            downloadAll: true);
                      } else {
                        igProfileDownloader.downloadProfile(
                            int.parse(userInfo['id']), numberOfPosts, true,
                            downloadAll: false);
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
