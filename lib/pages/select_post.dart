import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:igsaver/constants.dart';
import 'package:igsaver/models/posts_list.dart';
import 'package:igsaver/services/instagram_downloader.dart';
import 'package:igsaver/widgets/rounded_button.dart';
import 'package:igsaver/widgets/grid_item.dart';
import 'package:provider/provider.dart';

class SelectPost extends StatelessWidget {
  static const route = '/post_picker';

  // Scaffold and it's subtree moved to a separate method because provider not recognizing
  // Scaffold as Widget and throws error.
  Widget _buildPage(BuildContext context, Widget? _) {
    Map args = ModalRoute.of(context)?.settings.arguments as Map;
    int userID = int.parse(args['userID']);
    InstagramProfileDownloader igDownloader = InstagramProfileDownloader();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        elevation: 0,
        title: Provider.of<PostsList>(context).length == 0
            ? Text('Select Posts')
            : Text('${Provider.of<PostsList>(context).length} Post Selected'),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              // flex: 10,
              child: StreamBuilder<List<dynamic>>(
                stream: igDownloader.getProfilePosts(userID),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 5,
                        mainAxisSpacing: 5,
                      ),
                      itemCount: snapshot.data?.length,
                      itemBuilder: (context, index) {
                        var data = snapshot.data![index];
                        return GridItem(
                          data: data,
                          index: index,
                          selectedPosts: Provider.of<PostsList>(context),
                        );
                      },
                    );
                  } else {
                    return Center(
                      child: Text('Loading Data'),
                    );
                  }
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: FilledRoundedButton(
                text: 'Download Selected',
                onPressed: () {},
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<PostsList>(
      create: (context) => PostsList(),
      builder: _buildPage,
    );
  }
}
