import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:igsaver/constants.dart';
import 'package:igsaver/pages/image_viewer.dart';
import 'package:igsaver/pages/select_post.dart';
import 'package:igsaver/services/file_downloader.dart';
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
    var localization = AppLocalizations.of(context)!;

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return RoundedDialog(
          title: Text(localization.downloadAllPosts),
          children: <Widget>[
            RoundedButton(
              text: localization.downloadImagesOnly,
              onPressed: () async {
                profileDownloader.downloadAllPosts(userID, true);
              },
            ),
            FilledRoundedButton(
              text: localization.downloadAllPosts,
              onPressed: () async {
                profileDownloader.downloadAllPosts(userID, false);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var localization = AppLocalizations.of(context)!;
    Map args = ModalRoute.of(context)!.settings.arguments as Map;
    Map userInfo = args['userInfo'];
    var followers = _getRoundedFollowers(userInfo['followers']);
    final fileDownloader = FileDownloader();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        elevation: 0,
        title: Text(localization.downloadProfile),
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
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          ImageViewer.route,
                          arguments: {
                            'image': NetworkImage(userInfo['profilePicUrl']),
                            'child': FilledRoundedButton(
                              text: localization.saveToGallery,
                              onPressed: () {
                                fileDownloader.download(
                                  userInfo['profilePicUrl'],
                                  userInfo['username'],
                                );
                              },
                            )
                          },
                        );
                      },
                    ),
                    backgroundImage: NetworkImage(userInfo['profilePicUrl']),
                  ),
                  SizedBox(height: 15),
                  Container(
                    height: 120,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
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
                            if (userInfo['is_verified'])
                              Icon(
                                CupertinoIcons.check_mark_circled_solid,
                                size: 15,
                              ),
                          ],
                        ),
                        Text(
                          '${userInfo['postCount']} ${localization.posts} | $followers ${localization.followers}',
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 15,
                          ),
                        ),
                        if (userInfo['is_private'])
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.info,
                                size: 15,
                              ),
                              SizedBox(width: 5),
                              Text(
                                localization.accountIsPrivate,
                              ),
                            ],
                          ),
                        if (userInfo['postCount'] == 0)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.info,
                                size: 15,
                              ),
                              SizedBox(width: 5),
                              Text(
                                localization.accountHasNoPost,
                              ),
                            ],
                          ),
                        // SizedBox(height: 30),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      child: null,
                    ),
                  )
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                RoundedButton(
                  text: localization.selectPosts,
                  enabled:
                      !(userInfo['is_private'] || userInfo['postCount'] == 0),
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
                  text: localization.downloadAll,
                  enabled:
                      !(userInfo['is_private'] || userInfo['postCount'] == 0),
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
