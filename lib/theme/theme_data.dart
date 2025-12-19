import 'package:flutter/material.dart';

ThemeData getApplicationTheme() {
  return ThemeData(
    fontFamily: 'Jost Regular',
    scaffoldBackgroundColor: Colors.grey[200],
    textTheme: const TextTheme(
      bodyLarge: TextStyle(
        color: Colors.black,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
    ),

    //AppBarTheme
    appBarTheme: AppBarTheme(
      foregroundColor: Colors.black,
      backgroundColor: Colors.white,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontFamily: 'Jost SemiBold',
        color: Colors.black,
        fontSize: 22,
        letterSpacing: 0.5,
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(0)),
    ),

    //BottomNavigationTheme
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedIconTheme: IconThemeData(size: 28),
      unselectedIconTheme: IconThemeData(size: 28),
    ),
  );
}
