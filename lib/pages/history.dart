import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:igsaver/constants.dart';
import 'package:igsaver/models/download_history.dart';
import 'package:igsaver/pages/image_viewer.dart';
import 'package:provider/provider.dart';

class History extends StatefulWidget {
  static const route = '/history';

  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  Future<List<File>> _getImages() async {
    Directory dir = Directory('/storage/emulated/0/IGSaver/images');
    List<FileSystemEntity> entities = await dir.list().toList();
    Iterable<File> files = entities.whereType<File>();
    return files.toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        elevation: 0,
        title: Text('History'),
      ),
      body: SafeArea(
        child: FutureBuilder<List<File>>(
          future: _getImages(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisSpacing: 3,
                  crossAxisSpacing: 3,
                ),
                itemCount: snapshot.data?.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        ImageViewer.route,
                        arguments: {
                          'image_path': snapshot.data![index].path,
                        },
                      );
                    },
                    child: Image.file(
                      snapshot.data![index],
                      cacheWidth: 100,
                      fit: BoxFit.cover,
                    ),
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text(
                  'An Unexpected Error Occurred ',
                  style: TextStyle(fontSize: 16),
                ),
              );
            }
            return Center(
              child: Text(
                'Loading Images',
                style: TextStyle(fontSize: 16),
              ),
            );
          },
        ),
      ),
    );
  }
}

// Consumer<DownloadHistory>(
//           builder: (context, downloadHistory, child) {
//             List<Widget> listViewItems = [];
//             for (var item in downloadHistory.downloadsList) {
//               listViewItems.add(
//                 ListTile(
//                   leading: Icon(CupertinoIcons.arrow_down_circle),
//                   title: Text(item.title),
//                   subtitle: LinearProgressIndicator(
//                     value: item.percentage,
//                     color: kPrimaryColor,
//                     backgroundColor: Colors.grey[200],
//                   ),
//                 ),
//               );
//             }
//             return ListView(
//               reverse: true,
//               children: listViewItems,
//               // ListTile(
//               //   leading: Icon(CupertinoIcons.arrow_down_circle),
//               //   title: Text('Natgeo iuho8iugyuv.jpeg'),
//               //   subtitle: LinearProgressIndicator(
//               //     value: .25,
//               //     color: kPrimaryColor,
//               //     backgroundColor: Colors.grey[200],
//               //   ),
//               // ),
//               // ListTile(
//               //   leading: Icon(CupertinoIcons.check_mark_circled),
//               //   title: Text('Natgeo iuho8iugyuv.jpeg'),
//               //   subtitle: Text('Download Completed'),
//               // ),
//             );
//           },
//         ),

