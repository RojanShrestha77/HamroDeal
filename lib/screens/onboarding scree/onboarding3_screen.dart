import 'package:flutter/material.dart';

class OnboardingPage3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Get Ready!",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            // SizedBox(height: 20),
            // ElevatedButton(
            //   onPressed: () {
            //     // Navigate to Login Screen
            //     print("Go to Login Screen");
            //   },
            //   child: Text("Get Started"),
            // ),
          ],
        ),
      ),
    );
  }
}
