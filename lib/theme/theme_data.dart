import 'package:flutter/material.dart';

ThemeData getApplicationTheme() {
  return ThemeData(
    fontFamily: 'Jost Regular',
    scaffoldBackgroundColor: Color(0xFFFAFAFA),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(
        color: Colors.black,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
    ),

    appBarTheme: AppBarTheme(
      foregroundColor: Colors.black,
      backgroundColor: Colors.white,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontFamily: 'Jost SemiBold',
        color: Colors.black,
        fontSize: 22,
        letterSpacing: 0.5,
        // fontWeight: FontWeight.bold,
      ),
    ),
  );
}
