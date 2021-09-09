import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:photo_view/photo_view.dart';
import 'package:igsaver/constants.dart';

class ImageViewer extends StatelessWidget {
  static const route = '/image_viewer';

  @override
  Widget build(BuildContext context) {
    Map args = ModalRoute.of(context)!.settings.arguments as Map;
    String imagePath = args['image_path'];
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 9,
              child: PhotoView(
                imageProvider: FileImage(
                  File(imagePath),
                ),
              ),
              // Image.file(
              //   ,
              //   scale: 2.0,
              //   // fit: BoxFit.cover,
              // ),
            ),
            Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  IconButton(
                    onPressed: () {},
                    tooltip: 'Open Owner Profile',
                    icon: Icon(
                      CupertinoIcons.person_circle,
                      size: 30,
                      color: kPrimaryColor,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    tooltip: 'Open In Instagram',
                    icon: Icon(
                      CupertinoIcons.info_circle,
                      size: 30,
                      color: kPrimaryColor,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    tooltip: 'Delete Image',
                    icon: Icon(
                      CupertinoIcons.trash_circle,
                      size: 30,
                      color: kPrimaryColor,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
