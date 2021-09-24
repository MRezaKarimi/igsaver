import 'dart:async';
import 'package:flutter/services.dart' as flutterServices show Clipboard;

/// A wrapper around flutter [flutterServices.Clipboard]
class Clipboard {
  bool _active = true;
  final Duration duration = Duration(milliseconds: 500);

  /// Reads clipboard data in fixed time intervals and waits for new data.
  /// If a new data copied to the clipboard, it returns this data as [Stream].
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
}
