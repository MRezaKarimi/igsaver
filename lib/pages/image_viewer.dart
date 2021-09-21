import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ImageViewer extends StatelessWidget {
  static const route = '/image_viewer';

  @override
  Widget build(BuildContext context) {
    Map args = ModalRoute.of(context)!.settings.arguments as Map;
    String imagePath = args['image_path'];
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Center(
          child: PhotoView(
            imageProvider: FileImage(
              File(imagePath),
            ),
          ),
        ),
      ),
    );
  }
}
