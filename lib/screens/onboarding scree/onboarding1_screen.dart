import 'package:flutter/material.dart';

class OnboardingPage1 extends StatelessWidget {
  final PageController controller;

  const OnboardingPage1({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Welcome to My App!",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
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
