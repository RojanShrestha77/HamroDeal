import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final List<String> images = [
    'assets/images/image1.png',
    'assets/images/image2.avif',
    'assets/images/images3.jpg',
    'assets/images/image4.avif',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home", style: TextStyle(color: Color(0xFF1E1E1E))),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 1,
        iconTheme: IconThemeData(color: Color(0xFF1E1E1E)),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(15),
        itemCount: images.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: Text(
                "Hello Rojan! Welcome to your app.",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E1E1E),
                ),
                textAlign: TextAlign.center,
              ),
            );
          }
          return Card(
            margin: EdgeInsets.symmetric(vertical: 10),
            child: Image.asset(
              images[index - 1],
              fit: BoxFit.cover,
              width: double.infinity,
              height: 180,
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Color(0xFF147AFF),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}
