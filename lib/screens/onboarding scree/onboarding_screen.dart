import 'package:flutter/material.dart';
import 'package:hamro_deal/screens/onboarding%20scree/onboarding1_screen.dart';
import 'package:hamro_deal/screens/onboarding%20scree/onboarding2_screen.dart';
import 'package:hamro_deal/screens/onboarding%20scree/onboarding3_screen.dart';
// import 'onboarding_page1.dart';
// import 'onboarding_page2.dart';
// import 'onboarding_page3.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});
  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _controller,
            onPageChanged: (index) {
              setState(() {
                _current = index;
              });
            },
            children: [
              OnboardingPage1(controller: _controller),
              OnboardingPage2(controller: _controller),
              OnboardingPage3(),
            ],
          ),
          // Optional: Dots Indicator
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                3,
                (index) => Container(
                  margin: EdgeInsets.symmetric(horizontal: 5),
                  width: _current == index ? 12 : 8,
                  height: _current == index ? 12 : 8,
                  decoration: BoxDecoration(
                    color: _current == index ? Colors.blue : Colors.grey,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
