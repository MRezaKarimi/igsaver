import 'dart:async';
import 'package:flutter/services.dart' as flutterServices show Clipboard;

class Clipboard {
  bool _active = true;
  final Duration duration = Duration(milliseconds: 500);

  Stream<String> getClipboardData() async* {
    String currentData = '';

    while (_active) {
      var clipboardData = await flutterServices.Clipboard.getData('text/plain');
      if (clipboardData != null) {
        if (clipboardData.text != currentData) {
          currentData = clipboardData.text!;
          yield currentData;
        }
      }
      await Future.delayed(duration);
    }
  }

  void stop() {
    _active = false;
  }
}
