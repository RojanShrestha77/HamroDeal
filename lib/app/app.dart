import 'package:flutter/material.dart';
import 'package:hamro_deal/screens/splash_screen.dart';
import 'package:hamro_deal/theme/theme_data.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My App',
      theme: getApplicationTheme(),
      home: SplashScreen(),
    );
  }
}
