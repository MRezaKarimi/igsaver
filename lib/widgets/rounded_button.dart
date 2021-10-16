import 'package:flutter/material.dart';
import 'package:igsaver/constants.dart';

class RoundedButton extends StatelessWidget {
  final enabled;
  final String text;
  final void Function() onPressed;

  RoundedButton(
      {required this.text, required this.onPressed, this.enabled: true});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      child: Text(
        text,
        style: TextStyle(
          color: enabled ? kPrimaryColor : kPrimaryInactiveColor,
          fontSize: 18,
        ),
      ),
      style: OutlinedButton.styleFrom(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        side: BorderSide(
          color: enabled ? kPrimaryColor : kPrimaryInactiveColor,
          width: 2,
        ),
      ),
      onPressed: enabled ? onPressed : () {},
    );
  }
}

class FilledRoundedButton extends StatelessWidget {
  final enabled;
  final String text;
  final void Function() onPressed;

  FilledRoundedButton(
      {required this.text, required this.onPressed, this.enabled: true});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
        ),
      ),
      style: OutlinedButton.styleFrom(
        backgroundColor: enabled ? kPrimaryColor : kPrimaryInactiveColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        side:
            BorderSide(color: enabled ? kPrimaryColor : kPrimaryInactiveColor),
      ),
      onPressed: enabled ? onPressed : () {},
    );
  }
}
