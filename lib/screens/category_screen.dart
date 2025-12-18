import 'package:flutter/material.dart';

import 'package:hamro_deal/models/category_model.dart';
import 'package:hamro_deal/screens/category_products_screen.dart';

const List<CategoryModel> categories = [
  CategoryModel(id: "fashion", name: "Fashion", icon: Icons.checkroom),
  CategoryModel(id: "electronics", name: "Electronics", icon: Icons.devices),
  CategoryModel(id: "beauty", name: "Beauty", icon: Icons.spa),
  CategoryModel(id: "jewellery", name: "Jewellery", icon: Icons.diamond),
  CategoryModel(id: "footwear", name: "Footwear", icon: Icons.directions_walk),
  CategoryModel(id: "toys", name: "Toys", icon: Icons.toys),
  CategoryModel(id: "furniture", name: "Furniture", icon: Icons.weekend),
  CategoryModel(id: "mobiles", name: "Mobiles", icon: Icons.smartphone),
  CategoryModel(id: "home", name: "Home & Living", icon: Icons.home),
  CategoryModel(id: "sports", name: "Sports", icon: Icons.sports_soccer),
];

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Categories")),
      body: GridView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: categories.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 20,
          crossAxisSpacing: 20,
          childAspectRatio: 1, //(width/height)
        ),
        itemBuilder: (context, index) {
          final category = categories[index];

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      CategoryProductsScreen(category: category),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.black12),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(category.icon, size: 64, color: Colors.black),
                  const SizedBox(height: 16),
                  Text(
                    category.name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      fontFamily: 'Jost Bold',
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
