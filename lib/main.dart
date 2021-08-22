import 'package:flutter/material.dart';
import 'package:igsaver/pages/history.dart';
import 'package:igsaver/pages/settings.dart';
import 'package:igsaver/pages/home.dart';

void main() {
  runApp(IGSaver());
}

class IGSaver extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: Home.route,
      routes: {
        Home.route: (context) => Home(),
        Settings.route: (context) => Settings(),
        History.route: (context) => History(),
      },
    );
  }
}
// Row(
//   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//   children: [
//     Text(
//       'Watch Clipboard',
//       style: TextStyle(
//         fontSize: 17,
//         color: kPrimaryColor,
//       ),
//     ),
//     Switch(
//       value: false,
//       activeColor: kPrimaryColor,
//       activeTrackColor: kPrimaryColor,
//       onChanged: (value) {},
//     ),
//   ],
// ),