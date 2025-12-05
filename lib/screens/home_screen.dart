import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final List<Map<String, String>> products = [
    {
      "image": "assets/images/image1.png",
      "title": "Smartphone",
      "price": "\$299",
    },
    {
      "image": "assets/images/image2.avif",
      "title": "Headphones",
      "price": "\$49",
    },
    {"image": "assets/images/images3.jpg", "title": "Shoes", "price": "\$89"},
    {
      "image": "assets/images/image4.avif",
      "title": "Backpack",
      "price": "\$59",
    },
    {"image": "assets/images/image1.png", "title": "Watch", "price": "\$199"},
    {
      "image": "assets/images/image2.avif",
      "title": "Sunglasses",
      "price": "\$79",
    },
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // Decide number of columns based on screen width
    int crossAxisCount = 2;
    if (screenWidth >= 1200) {
      crossAxisCount = 4; // Large tablet
    } else if (screenWidth >= 800) {
      crossAxisCount = 3; // Small tablet
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
        title: Text("Home", style: TextStyle(color: Color(0xFF1E1E1E))),
        iconTheme: IconThemeData(color: Color(0xFF1E1E1E)),
      ),
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.02), // responsive padding
        child: Column(
          children: [
            // Greeting
            Text(
              "Hello Rojan! Welcome to your app.",
              style: TextStyle(
                fontSize: screenWidth * 0.025, // responsive font size
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E1E1E),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: screenWidth * 0.02),

            // Search bar
            TextField(
              decoration: InputDecoration(
                hintText: "Search products...",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: EdgeInsets.symmetric(
                  vertical: 0,
                  horizontal: 16,
                ),
              ),
            ),
            SizedBox(height: screenWidth * 0.02),

            // Product grid
            Expanded(
              child: GridView.builder(
                itemCount: products.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.7,
                ),
                itemBuilder: (context, index) {
                  final product = products[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.asset(
                                product["image"]!,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            product["title"]!,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: screenWidth * 0.018,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 4),
                          Text(
                            product["price"]!,
                            style: TextStyle(
                              color: Color(0xFF147AFF),
                              fontWeight: FontWeight.bold,
                              fontSize: screenWidth * 0.018,
                            ),
                          ),
                          SizedBox(height: 8),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF147AFF),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                padding: EdgeInsets.symmetric(vertical: 8),
                              ),
                              child: Text(
                                "Add to Cart",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: screenWidth * 0.016,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Color(0xFF147AFF),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: "Cart",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}
