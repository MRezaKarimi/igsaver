import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
    var localization = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        elevation: 0,
        title: Text(localization.settings),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            SettingsCard(
              title: localization.watchClipboard,
              description: localization.watchClipboardDesc,
              switchValue: clipboardSwitch,
              switchCallback: (bool value) {
                setState(() {
                  clipboardSwitch = value;
                });
                settings.set(SettingsService.watchClipboard, value);
              },
            ),
            SettingsCard(
              title: localization.onlyDownloadImages,
              description: localization.onlyDownloadImagesDesc,
              switchValue: imagesOnlySwitch,
              switchCallback: (bool value) {
                setState(() {
                  imagesOnlySwitch = value;
                });
                settings.set(SettingsService.imagesOnly, value);
              },
            ),
            SettingsCard(
              title: localization.showNotification,
              description: localization.showNotificationDesc,
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
