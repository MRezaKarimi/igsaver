import 'dart:io';
import 'package:dio/dio.dart';
import 'package:igsaver/services/notification.dart';
import 'package:igsaver/services/settings_service.dart';

/// Downloads files from a remote server and saves them to local storage.
class FileDownloader {
  final Dio _dio = Dio(
    BaseOptions(
      headers: {
        'User-Agent':
            'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:79.0) Gecko/20100101 Firefox/79.0'
      },
    ),
  );
  final String _imagesDownloadPath = '/storage/emulated/0/IGSaver/images';
  final String _videosDownloadPath = '/storage/emulated/0/IGSaver/videos';

  final Notification notification = Notification();
  final SettingsService settings = SettingsService();

  FileDownloader() {
    _createDirectories();
  }

  void _createDirectories() async {
    await Directory(_imagesDownloadPath).create(recursive: true);
    await Directory(_videosDownloadPath).create(recursive: true);
  }

  Future<void> download(String url, String filename,
      {bool isVideo: false}) async {
    if (isVideo) {
      await _dio.download(url, '$_videosDownloadPath/$filename');
    } else {
      await _dio.download(url, '$_imagesDownloadPath/$filename');
    }

    if (settings.get(SettingsService.showNotification, true)) {
      notification.show(filename);
    }
  }
}
