import 'package:flutter/material.dart';
import 'package:igsaver/constants.dart';

class SettingsCard extends StatelessWidget {
  final bool switchValue;
  final String title;
  final String description;
  final void Function(bool value) switchCallback;

  SettingsCard({
    required this.switchValue,
    required this.title,
    required this.description,
    required this.switchCallback,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: Material(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        child: Padding(
          padding: EdgeInsets.only(left: 10, right: 5, top: 5, bottom: 10),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 17,
                      // color: kPrimaryColor,
                    ),
                  ),
                  Switch(
                    value: switchValue,
                    activeColor: kPrimaryColor,
                    activeTrackColor: kPrimaryShadowColor,
                    onChanged: switchCallback,
                  ),
                ],
              ),
              Text(
                description,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[500],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
