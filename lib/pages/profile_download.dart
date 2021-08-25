import 'package:flutter/material.dart';
import 'package:igsaver/constants.dart';
import 'package:igsaver/widgets/settings_card.dart';

class ProfileDownload extends StatefulWidget {
  static const route = '/profile_download';

  @override
  _ProfileDownloadState createState() => _ProfileDownloadState();
}

class _ProfileDownloadState extends State<ProfileDownload> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        elevation: 0,
        title: Text('Settings'),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: <Widget>[
                CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(
                      'https://scontent-mct1-1.cdninstagram.com/v/t51.2885-19/s150x150/95140556_594026277870211_4156802974091313152_n.jpg?_nc_ht=scontent-mct1-1.cdninstagram.com&_nc_ohc=g3BLwrle_g4AX9o_kKl&edm=ABfd0MgBAAAA&ccb=7-4&oh=f96b7e35c1808aedcb17d3644bf34ec9&oe=612BF5E4&_nc_sid=7bff83'),
                ),
                SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'National Geographic',
                      style: TextStyle(fontSize: 20),
                    ),
                    Text(
                      '@natgeo',
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
            )
          ],
        ),
      ),
    );
  }
}
