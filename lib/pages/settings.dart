import 'package:flutter/material.dart';
import 'package:igsaver/constants.dart';
import 'package:igsaver/widgets/settings_card.dart';

class Settings extends StatefulWidget {
  static const route = '/settings';

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool clipboardSwitch = true;
  bool vibrateSwitch = true;
  bool onlyImageSwitch = true;

  @override
  Widget build(BuildContext context) {
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
                  'Automatically start downloading when URL copied to the clipboard.',
              switchValue: clipboardSwitch,
              switchCallback: (bool value) {},
            ),
            SettingsCard(
              title: 'Vibrate On Download',
              description: 'Vibrate when a post downloaded successfully.',
              switchValue: vibrateSwitch,
              switchCallback: (bool value) {},
            ),
            SettingsCard(
              title: 'Only Download Images',
              description:
                  'Skip downloading videos when new url copied to the clipboard. Turning this off results in more data usage.',
              switchValue: onlyImageSwitch,
              switchCallback: (bool value) {},
            ),
          ],
        ),
      ),
    );
  }
}
