import 'package:flutter/material.dart';
import 'pages/home.dart';

void main() {
  runApp(IGSaver());
}

class IGSaver extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => Home(),
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