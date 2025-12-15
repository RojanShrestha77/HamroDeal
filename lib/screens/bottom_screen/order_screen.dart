import 'package:flutter/material.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Order")),
      body: const Center(
        child: Text(
          "This is the Orders Screen",
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
