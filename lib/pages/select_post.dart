import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
    var localization = AppLocalizations.of(context)!;
    Map args = ModalRoute.of(context)?.settings.arguments as Map;
    int userID = int.parse(args['userID']);
    var profileDownloader = InstagramProfileDownloader();

    return ChangeNotifierProvider<PostsList>(
      create: (context) => PostsList(),
      builder: (context, _) => Scaffold(
        appBar: AppBar(
          backgroundColor: kPrimaryColor,
          elevation: 0,
          title: Consumer<PostsList>(builder: (context, postsList, _) {
            if (Provider.of<PostsList>(context).length == 0) {
              return Text(localization.selectPosts);
            } else {
              return Text(
                  '${Provider.of<PostsList>(context).length} ${localization.postSelected}');
            }
          }),
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
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          localization.unexpectedError,
                          style: TextStyle(fontSize: 16),
                        ),
                      );
                    } else {
                      return Center(
                        child: Text(localization.loadingData),
                      );
                    }
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: FilledRoundedButton(
                  text: localization.downloadSelected,
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
