import 'package:flutter/cupertino.dart';
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

  String _getRoundedFollowers(int num) {
    if (num > 1000000) {
      return (num / 1000000).toStringAsFixed(1) + 'm';
    }
    if (num > 1000) {
      return (num / 1000).toStringAsFixed(1) + 'k';
    } else {
      return num.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    Map args = ModalRoute.of(context)!.settings.arguments as Map;
    Map userInfo = args['userInfo'];
    String followers = _getRoundedFollowers(userInfo['followers']);

    return Scaffold(
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
              // flex: 3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  CircleAvatar(
                    radius: 100,
                    backgroundImage: NetworkImage(userInfo['profilePicUrl']),
                  ),
                  Text(
                    userInfo['name'],
                    style: TextStyle(fontSize: 20),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '@${userInfo['username']}',
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 15,
                        ),
                      ),
                      SizedBox(width: 5),
                      Icon(
                        CupertinoIcons.check_mark_circled_solid,
                        size: 15,
                        color: userInfo['is_verified']
                            ? Colors.black
                            : Colors.transparent,
                      ),
                    ],
                  ),
                  Text(
                    '${userInfo['postCount']} Posts | $followers Followers',
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 15,
                    ),
                  ),
                  SizedBox(height: 30),
                ],
              ),
            ),
            Row(
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
                    /*if (downloadAllSwitch) {
                      igProfileDownloader.downloadProfile(
                          int.parse(userInfo['id']), numberOfPosts, true,
                          downloadAll: true);
                    } else {
                      igProfileDownloader.downloadProfile(
                          int.parse(userInfo['id']), numberOfPosts, true,
                          downloadAll: false);
                    }*/
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
