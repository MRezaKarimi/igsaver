import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class SettingsService {
  static Future<void> initialize() async {
    await Hive.initFlutter();
    await Hive.openBox('settings');
  }

  static const clipboard = 'CLIPBOARD';
  static const vibrate = 'VIBRATE';
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
