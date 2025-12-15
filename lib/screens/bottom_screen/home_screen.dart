import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        // ensures content is below status bar
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: const [
                Text("Hello world"),
                SizedBox(height: 20),
                Text("More content here..."),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
