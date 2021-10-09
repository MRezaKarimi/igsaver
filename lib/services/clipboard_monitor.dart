import 'dart:async';
import 'package:flutter/services.dart';
import 'package:igsaver/exceptions/exceptions.dart';
import 'package:igsaver/services/instagram_downloader.dart';
import 'package:igsaver/services/settings_service.dart';

/// Utilities for monitoring clipboard and auto-download instagram posts when new URL
/// copied to the clipboard.
class ClipboardMonitor {
  final duration = Duration(milliseconds: 500);
  final settings = SettingsService();
  final igPostDownloader = InstagramPostDownloader();

  /// Reads clipboard data in fixed time intervals and waits for new data.
  /// If a new data copied to the clipboard, it returns this data as [Stream].
  Stream<String> _getClipboardData() async* {
    var currentData = '';

    while (true) {
      var clipboardData = await Clipboard.getData('text/plain');
      if (clipboardData != null) {
        if (clipboardData.text != currentData) {
          currentData = clipboardData.text!;
          yield currentData;
        }
      }
      await Future.delayed(duration);
    }
  }

  /// Listens to [_getClipboardData] for new clipboard data.
  /// If new data is available, calls [InstagramPostDownloader.downloadPost].
  void start() async {
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
