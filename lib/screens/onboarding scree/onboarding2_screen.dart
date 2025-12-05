import 'package:flutter/material.dart';

class OnboardingPage2 extends StatelessWidget {
  final PageController controller;
  const OnboardingPage2({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Welcome to My app"),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                controller.nextPage(
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeIn,
                );
              },
              child: Text("Next"),
            ),
          ],
        ),
      ),
    );
  }
}
