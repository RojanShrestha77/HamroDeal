import 'package:flutter/material.dart';
import 'package:hamro_deal/models/category_model.dart';
import 'package:hamro_deal/models/product_model.dart';
import 'package:hamro_deal/features/home/presentation/widgets/vertical_product_card.dart';

class Subcategory {
  final String id;
  final String name;

  const Subcategory({required this.id, required this.name});
}

class CategoryProductsScreen extends StatefulWidget {
  final CategoryModel category;
  const CategoryProductsScreen({super.key, required this.category});

  @override
  State<CategoryProductsScreen> createState() => _CategoryProductsScreenState();
}

class _CategoryProductsScreenState extends State<CategoryProductsScreen> {
  String selectedSubId = "all";

  List<Subcategory> get subcategories {
    switch (widget.category.id) {
      case "electronics":
        return const [
          Subcategory(id: "all", name: "All"),
          Subcategory(id: "mobile", name: "Mobiles"),
          Subcategory(id: "laptops", name: "Laptops"),
          Subcategory(id: "headphones", name: "Headphones"),
        ];
      case "fashion":
        return const [
          Subcategory(id: "all", name: "All"),
          Subcategory(id: "shoes", name: "Shoes"),
          Subcategory(id: "bags", name: "Bags"),
        ];
      default:
        return const [Subcategory(id: "all", name: "All")];
    }
  }

  List<Product> get filteredProducts {
    final categoryProducts = products
        .where((p) => p.categoryId == widget.category.id)
        .toList();
    //checking the main category first

    // return all the sub category if the user clicks all
    if (selectedSubId == "all") return categoryProducts;

    return categoryProducts
        .where((p) => p.subcategoryId == selectedSubId)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          widget.category.name,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Column(
        children: [
          SizedBox(
            height: 60,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: subcategories.map((sub) {
                final isSelected = selectedSubId == sub.id;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: FilterChip(
                    label: Text(sub.name),
                    selected: isSelected,
                    onSelected: (_) {
                      setState(() {
                        selectedSubId = sub.id;
                      });
                    },
                    backgroundColor: Colors.white,
                    selectedColor: Colors.black,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    side: const BorderSide(color: Colors.black, width: 1.5),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          //Product GRid
          // Expanded(
          //   child: filteredProducts.isEmpty
          //       ? const Center(
          //           child: Text(
          //             "No products available",
          //             style: TextStyle(fontSize: 18, color: Colors.black54),
          //           ),
          //         )
          //       : GridView.builder(
          //           padding: const EdgeInsets.all(16),
          //           itemCount: filteredProducts.length,
          //           gridDelegate:
          //               const SliverGridDelegateWithFixedCrossAxisCount(
          //                 crossAxisCount: 2,
          //                 childAspectRatio: 0.7, //(width/height)
          //                 mainAxisSpacing: 16,
          //                 crossAxisSpacing: 16,
          //               ),
          //           itemBuilder: (context, index) {
          //             final product = filteredProducts[index];
          //             // return VerticalProductCard(
          //             //   title: product.title,
          //             //   image: product.image,
          //             // );
          //           },
          //         ),
          // ),
        ],
      ),
    );
  }
}
