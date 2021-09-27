import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:igsaver/constants.dart';
import 'package:igsaver/pages/image_viewer.dart';

class History extends StatelessWidget {
  static const route = '/history';

  /// Reads images from IGSaver download directory and
  /// returns a list of [File] objects sorted based on last modified date.
  Future<List<File>> _getImages() async {
    var dir = Directory('/storage/emulated/0/IGSaver/images');
    var entities = await dir.list().toList();
    var files = entities.whereType<File>();
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
                          'image': FileImage(
                            File(snapshot.data![index].path),
                          ),
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
            } else {
              return Center(
                child: Text(
                  'Loading Images',
                  style: TextStyle(fontSize: 16),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
