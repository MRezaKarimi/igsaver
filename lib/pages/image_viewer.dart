import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:igsaver/constants.dart';
import 'package:photo_view/photo_view.dart';

class ImageViewer extends StatelessWidget {
  static const route = '/image_viewer';

  @override
  Widget build(BuildContext context) {
    Map args = ModalRoute.of(context)!.settings.arguments as Map;
    ImageProvider image = args['image'];
    Widget? child = args['child'];

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: PhotoView(
                imageProvider: image,
                minScale: PhotoViewComputedScale.contained * 1,
              ),
            ),
            Container(
              child: child,
            )
          ],
        ),
      ),
    );
  }
}
