import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:igsaver/constants.dart';
import 'package:igsaver/pages/image_viewer.dart';

class History extends StatefulWidget {
  static const route = '/history';

  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  /// Reads images from IGSaver download directory and
  /// returns a list of [File] objects sorted based on last modified date.
  Future<List<File>> _getImages() async {
    Directory dir = Directory('/storage/emulated/0/IGSaver/images');
    List<FileSystemEntity> entities = await dir.list().toList();
    Iterable<File> files = entities.whereType<File>();
    return files.toList()
      ..sort((a, b) {
        return b.lastModifiedSync().compareTo(a.lastModifiedSync());
      });
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
