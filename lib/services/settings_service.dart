import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// A Service to work with settings and user preferences.
class SettingsService {
  /// Initializes [Hive] and opens box in which settings and preferences stored.
  /// This should be called asynchronously in loading page or when app started to prevent
  /// [HiveError] exception.
  static Future<void> initialize() async {
    await Hive.initFlutter();
    await Hive.openBox('settings');
  }

  static const watchClipboard = 'CLIPBOARD';
  static const showNotification = 'VIBRATE';
  static const imagesOnly = 'IMAGES_ONLY';

  bool get(String key, bool defaultValue) {
    var settings = Hive.box('settings');
    return settings.get(key, defaultValue: defaultValue);
  }

  void set(String key, bool value) {
    var settings = Hive.box('settings');
    settings.put(key, value);
  }
}
