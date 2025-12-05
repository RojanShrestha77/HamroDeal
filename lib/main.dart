import 'package:flutter/material.dart';
import 'package:hamro_deal/screens/splash_screen.dart';
// import 'splash_screen.dart';
// import 'onboarding_screen.dart';
// import 'login_screen.dart';
// import 'register_screen.dart';
// import 'home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: SplashScreen(),
    );
  }
}
