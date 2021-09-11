import 'package:flutter/material.dart';
import 'package:igsaver/constants.dart';

class RoundedButton extends StatelessWidget {
  final String text;
  final void Function() onPressed;

  RoundedButton({required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      child: Text(
        text,
        style: TextStyle(
          color: kPrimaryColor,
          fontSize: 18,
        ),
      ),
      style: OutlinedButton.styleFrom(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        side: BorderSide(color: kPrimaryColor, width: 2),
      ),
      onPressed: onPressed,
    );
  }
}

class FilledRoundedButton extends StatelessWidget {
  final String text;
  final void Function() onPressed;

  FilledRoundedButton({required this.text, required this.onPressed});

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
        backgroundColor: kPrimaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        side: BorderSide(color: kPrimaryColor),
      ),
      onPressed: onPressed,
    );
  }
}
