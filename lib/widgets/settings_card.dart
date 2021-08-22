import 'package:flutter/material.dart';
import 'package:igsaver/constants.dart';

class SettingsCard extends StatefulWidget {
  bool switchValue;
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
  _SettingsCardState createState() => _SettingsCardState();
}

class _SettingsCardState extends State<SettingsCard> {
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
                    widget.title,
                    style: TextStyle(
                      fontSize: 17,
                      // color: kPrimaryColor,
                    ),
                  ),
                  Switch(
                    value: widget.switchValue,
                    activeColor: kPrimaryColor,
                    activeTrackColor: kPrimaryShadowColor,
                    onChanged: (value) {
                      setState(() {
                        widget.switchValue = value;
                      });
                      widget.switchCallback(value);
                    },
                  ),
                ],
              ),
              Text(
                widget.description,
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
