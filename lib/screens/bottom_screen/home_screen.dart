import 'package:flutter/material.dart';
import 'package:hamro_deal/screens/bottom_screen/search_screen.dart';
import 'package:hamro_deal/widgets/vertical_product_card.dart';
import 'package:hamro_deal/widgets/horizontal_product_card.dart';
import 'package:hamro_deal/models/product_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          // ← Makes the whole page scrollable
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Search Bar
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const SearchScreen()),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    height: 50,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE0E0E0),
                      borderRadius: BorderRadius.circular(32),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search, color: Colors.black),
                        SizedBox(width: 8),
                        Text(
                          "Search",
                          style: TextStyle(color: Colors.black, fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Horizontal List Title
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    "Recommended For You",
                    style: TextStyle(fontSize: 20, fontFamily: 'Jost Bold'),
                  ),
                ),
                const SizedBox(height: 16),

                // Horizontal ListView
                SizedBox(
                  height: 300, // Keep fixed height for horizontal scroll
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    scrollDirection: Axis.horizontal,
                    itemCount: 6,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (_, index) => const HorizontalProductCard(
                      title: "Shoes",
                      image: "assets/images/image1.png",
                    ),
                  ),
                ),

                const SizedBox(height: 44),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  color: Colors.black,
                  child: const Text(
                    "SHOP NOW",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                      fontFamily: 'Jost Bold',
                    ),
                  ),
                ),

                const SizedBox(height: 4),

                // Vertical GridView (now inside scrollable column)
                GridView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  physics: const NeverScrollableScrollPhysics(), // Important!
                  shrinkWrap:
                      true, // Important! Allows GridView inside SingleChildScrollView
                  itemCount: products.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.7,
                  ),
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return VerticalProductCard(
                      title: product.title,
                      image: product.image,
                    );
                  },
                ),

                const SizedBox(height: 24), // Extra bottom space
              ],
            ),
          ),
        ),
      ),
    );
  }
}
