import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:igsaver/constants.dart';
import 'package:igsaver/pages/select_post.dart';
import 'package:igsaver/services/instagram_downloader.dart';
import 'package:igsaver/widgets/rounded_button.dart';
import 'package:igsaver/widgets/rounded_dialog.dart';

class ProfileDownload extends StatefulWidget {
  static const route = '/profile_download';

  @override
  _ProfileDownloadState createState() => _ProfileDownloadState();
}

class _ProfileDownloadState extends State<ProfileDownload> {
  InstagramProfileDownloader profileDownloader = InstagramProfileDownloader();

  /// Gets number of followers and returns a human readable string.
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

  /// Shows user a dialog with two [RoundedButton] and asks user
  /// to select which methods should be used to download profile posts.
  ///
  /// Two available methods are:
  /// 1. Download Images Only: only download images and ignore videos and IGTVs
  /// 2. Download All Posts: download all posts, images and videos
  Future<void> _showDownloadConfirmDialog(int userID) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return RoundedDialog(
          title: Text('Download Profile Posts'),
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                RoundedButton(
                  text: 'Download Images Only',
                  onPressed: () async {
                    profileDownloader.downloadAllPosts(userID, true);
                  },
                ),
                FilledRoundedButton(
                  text: 'Download All Posts',
                  onPressed: () async {
                    profileDownloader.downloadAllPosts(userID, false);
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Map args = ModalRoute.of(context)!.settings.arguments as Map;
    Map userInfo = args['userInfo'];

    String followers = _getRoundedFollowers(userInfo['followers']);

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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  CircleAvatar(
                    radius: 100,
                    child: GestureDetector(
                      onLongPress: () {
                        print('object');
                      },
                    ),
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
                    _showDownloadConfirmDialog(int.parse(userInfo['id']));
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
