import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hamro_deal/core/services/storage/user_session_service.dart';
import 'package:hamro_deal/screens/bottom_screen/home_screen.dart';
import 'package:hamro_deal/screens/onboarding/onboarding_screen.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateNext();
  }

  void _navigateNext() async {
    await Future.delayed(const Duration(seconds: 3));

    if (!mounted) return;

    final userSessionService = ref.read(userSessionServiceProvider);
    final isLoggedIn = await userSessionService.isLoggedIn();

    if (isLoggedIn) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const OnboardingScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset('assets/images/logo.png', width: 250, height: 250),
      ),
    );
  }
}
