import 'dart:async';

import 'package:flutter/services.dart' as flutterServices show Clipboard;

class Clipboard {
  bool _active = true;

  Stream<String> getClipboardData() async* {
    String? currentData;
    print(currentData);
    while (_active) {
      var clipboardData = await flutterServices.Clipboard.getData(
          flutterServices.Clipboard.kTextPlain);
      if (clipboardData?.text != null && clipboardData?.text != currentData) {
        currentData = clipboardData!.text;
        yield currentData!;
      }
      await Future.delayed(Duration(milliseconds: 500));
      // sleep(Duration(milliseconds: 500));
    }
  }

  void stop() {
    _active = false;
  }
}
