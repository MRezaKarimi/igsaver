import 'package:flutter/material.dart';
import 'package:igsaver/constants.dart';
import 'package:igsaver/widgets/settings_card.dart';

class Settings extends StatefulWidget {
  static const route = '/settings';

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool clipboardSwitch = false;
  bool backgroundSwitch = false;

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
              title: 'Run In Background',
              description:
                  'Allow this app to run a service in background to watch clipboard and download posts.',
              switchValue: clipboardSwitch,
              switchCallback: (bool value) {},
            ),
          ],
        ),
      ),
    );
  }
}
