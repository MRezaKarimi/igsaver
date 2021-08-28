import 'package:flutter/material.dart';
import 'package:igsaver/constants.dart';

class RoundedBottomAppBar extends StatelessWidget {
  final List<Widget> children;

  RoundedBottomAppBar({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: kPrimaryColor,
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: children,
      ),
    );
  }
}
