import 'package:flutter/material.dart';

class MyTextformfield extends StatelessWidget {
  const MyTextformfield({
    super.key,
    required this.firstcontroller,
    required this.text,
    this.validator, // optional custom validator
    this.obscureText = false, // optional for password fields
    this.keyboardType, // optional keyboard type
  });

  final TextEditingController firstcontroller;
  final String text;
  final String? Function(String?)? validator;
  final bool obscureText;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: firstcontroller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator:
          validator ??
          (value) {
            if (value == null || value.trim().isEmpty) {
              return "Please enter $text";
            }
            return null;
          },
      decoration: InputDecoration(
        labelText: text,
        hintText: text,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
