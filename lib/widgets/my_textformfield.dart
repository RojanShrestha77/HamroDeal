import 'package:flutter/material.dart';

class MyTextformfield extends StatelessWidget {
  const MyTextformfield({
    super.key,
    required this.firstcontroller,
    required this.text,
  });

  final TextEditingController firstcontroller;
  final String text;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: firstcontroller,
      decoration: InputDecoration(
        labelText: text,
        hintText: text,
        border: const OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return "Please enter the $text";
        }
        return null;
      },
    );
  }
}
