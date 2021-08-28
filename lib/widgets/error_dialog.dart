import 'package:flutter/material.dart';
import 'package:igsaver/widgets/rounded_dialog.dart';

class ErrorDialog {
  static Future<void> show(BuildContext context,
      {required String title, required String message}) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return RoundedDialog(
          title: Text(title),
          children: <Widget>[
            Text(
              message,
              style: TextStyle(fontSize: 17),
            )
          ],
        );
      },
    );
  }
}
