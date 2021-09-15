import 'package:flutter/material.dart';

class RoundedDialog extends StatefulWidget {
  final List<Widget> children;
  final Widget title;

  RoundedDialog({required this.title, required this.children});

  @override
  _RoundedDialogState createState() => _RoundedDialogState();
}

class _RoundedDialogState extends State<RoundedDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 24.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      title: widget.title,
      content: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: widget.children,
        ),
      ),
    );
  }
}
