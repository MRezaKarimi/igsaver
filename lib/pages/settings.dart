import 'package:flutter/material.dart';
import 'package:igsaver/constants.dart';
import 'package:igsaver/services/settings_service.dart';
import 'package:igsaver/widgets/settings_card.dart';

class Settings extends StatefulWidget {
  static const route = '/settings';

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  SettingsService settings = SettingsService();

  @override
  Widget build(BuildContext context) {
    bool clipboardSwitch = settings.get(SettingsService.watchClipboard, true);
    bool notificationSwitch =
        settings.get(SettingsService.showNotification, true);
    bool imagesOnlySwitch = settings.get(SettingsService.imagesOnly, true);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        elevation: 0,
        title: Text('Settings'),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            SettingsCard(
              title: 'Watch Clipboard',
              description:
                  'Automatically download post when URL copied to the clipboard. Restart required if changed.',
              switchValue: clipboardSwitch,
              switchCallback: (bool value) {
                setState(() {
                  clipboardSwitch = value;
                });
                settings.set(SettingsService.watchClipboard, value);
              },
            ),
            SettingsCard(
              title: 'Only Download Images',
              description:
                  'Skip downloading videos when new url copied to the clipboard. Turning this off, results in more data usage.',
              switchValue: imagesOnlySwitch,
              switchCallback: (bool value) {
                setState(() {
                  imagesOnlySwitch = value;
                });
                settings.set(SettingsService.imagesOnly, value);
              },
            ),
            SettingsCard(
              title: 'Show Notification',
              description: 'Show notification when download completed.',
              switchValue: notificationSwitch,
              switchCallback: (bool value) {
                setState(() {
                  notificationSwitch = value;
                });
                settings.set(SettingsService.showNotification, value);
              },
            ),
          ],
        ),
      ),
    );
  }
}
