import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:igsaver/constants.dart';
import 'package:igsaver/models/posts_list.dart';
import 'package:igsaver/services/instagram_downloader.dart';
import 'package:igsaver/widgets/rounded_button.dart';
import 'package:igsaver/widgets/grid_item.dart';
import 'package:provider/provider.dart';

class SelectPost extends StatelessWidget {
  static const route = '/select_post';

  @override
  Widget build(BuildContext context) {
    Map args = ModalRoute.of(context)?.settings.arguments as Map;
    int userID = int.parse(args['userID']);
    InstagramProfileDownloader profileDownloader = InstagramProfileDownloader();

    return ChangeNotifierProvider<PostsList>(
      create: (context) => PostsList(),
      builder: (context, _) => Scaffold(
        appBar: AppBar(
          backgroundColor: kPrimaryColor,
          elevation: 0,
          title: CounterText(),
        ),
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: StreamBuilder<List<dynamic>>(
                  stream: profileDownloader.getProfilePosts(userID),
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
                            selectedPosts:
                                Provider.of<PostsList>(context, listen: false),
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
                  onPressed: () {
                    profileDownloader.downloadSelectedPosts(
                        Provider.of<PostsList>(context, listen: false));
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class CounterText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (Provider.of<PostsList>(context).length == 0) {
      return Text('Select Posts');
    } else {
      return Text('${Provider.of<PostsList>(context).length} Post Selected');
    }
  }
}
