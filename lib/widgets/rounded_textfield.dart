import 'package:flutter/material.dart';
import 'package:igsaver/constants.dart';

class RoundedTextField extends StatelessWidget {
  final String hint;
  final void Function(String) onChanged;
  final TextInputType keyboardType;

  RoundedTextField({
    required this.hint,
    required this.onChanged,
    this.keyboardType: TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: kPrimaryColor, width: 1.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: kPrimaryColor, width: 2.0),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        hintText: hint,
        isDense: true,
      ),
      keyboardType: keyboardType,
      onChanged: onChanged,
    );
  }
}
