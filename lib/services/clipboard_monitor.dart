import 'dart:async';
import 'package:flutter/services.dart';
import 'package:igsaver/exceptions/exceptions.dart';
import 'package:igsaver/services/instagram_downloader.dart';
import 'package:igsaver/services/settings_service.dart';

/// Utilities for monitoring clipboard and auto-download instagram posts when new URL
/// copied to the clipboard.
class ClipboardMonitor {
  /// Reads clipboard data in fixed time intervals and waits for new data.
  /// If a new data copied to the clipboard, it returns this data as [Stream].
  static Stream<String> _getClipboardData() async* {
    var currentData = '';

    while (true) {
      var clipboardData = await Clipboard.getData('text/plain');
      if (clipboardData != null) {
        if (clipboardData.text != currentData) {
          currentData = clipboardData.text!;
          yield currentData;
        }
      }
      await Future.delayed(Duration(milliseconds: 500));
    }
  }

  /// Listens to [_getClipboardData] for new clipboard data.
  /// If new data is available, calls [InstagramPostDownloader.downloadPost].
  static void start() async {
    final settings = SettingsService();
    final igPostDownloader = InstagramPostDownloader();

    if (settings.get(SettingsService.watchClipboard, true)) {
      await for (var data in _getClipboardData()) {
        try {
          await igPostDownloader.downloadPost(
            data,
            settings.get(SettingsService.imagesOnly, true),
          );
        } on InvalidUrlException {
          continue;
        } on PostNotFoundException {
          continue;
        }
      }
    }
  }
}
