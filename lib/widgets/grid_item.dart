import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:igsaver/constants.dart';

class GridItem extends StatefulWidget {
  final data;
  final bool selected;
  final void Function() onTap;

  GridItem({required this.data, required this.onTap, required this.selected});

  @override
  _GridItemState createState() => _GridItemState();
}

class _GridItemState extends State<GridItem> {
  bool selected = false;

  Widget? _getTileIcon(data) {
    if (data['__typename'] == 'GraphSidecar') {
      return Icon(
        CupertinoIcons.rectangle_fill_on_rectangle_fill,
        color: Colors.white,
        size: 20,
      );
    } else if (data['__typename'] == 'GraphVideo') {
      return Icon(
        CupertinoIcons.play_fill,
        color: Colors.white,
        size: 20,
      );
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selected = !selected;
        });
      },
      child: Stack(
        children: [
          Align(
            alignment: AlignmentDirectional.center,
            child: Image.network(
              widget.data['thumbnail_resources'][0]['src'],
              fit: BoxFit.cover,
            ),
          ),
          Align(
            alignment: AlignmentDirectional(0.9, -0.9),
            child: _getTileIcon(widget.data),
          ),
          Align(
            alignment: AlignmentDirectional.bottomStart,
            child: selected
                ? Icon(
                    CupertinoIcons.check_mark_circled_solid,
                    color: kPrimaryColor,
                  )
                : null,
          )
        ],
      ),
    );
  }
}

class GGridItem extends StatelessWidget {
  final data;
  final bool selected;
  final void Function() onTap;

  GGridItem({required this.data, required this.onTap, required this.selected});

  Widget? _getTileIcon(data) {
    if (data['__typename'] == 'GraphSidecar') {
      return Icon(
        CupertinoIcons.rectangle_fill_on_rectangle_fill,
        color: Colors.white,
        size: 20,
      );
    } else if (data['__typename'] == 'GraphVideo') {
      return Icon(
        CupertinoIcons.play_fill,
        color: Colors.white,
        size: 20,
      );
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Align(
            alignment: AlignmentDirectional.center,
            child: Image.network(
              data['thumbnail_resources'][0]['src'],
              fit: BoxFit.cover,
            ),
          ),
          Align(
            alignment: AlignmentDirectional(0.9, -0.9),
            child: _getTileIcon(data),
          ),
          Align(
            alignment: AlignmentDirectional.bottomStart,
            child: selected
                ? Icon(
                    CupertinoIcons.check_mark_circled_solid,
                    color: kPrimaryColor,
                  )
                : null,
          )
        ],
      ),
    );
  }
}
