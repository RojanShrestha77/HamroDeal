class Product {
  final String title;
  final String image;
  final String categoryId; // main category
  final String subcategoryId; // subcategory

  Product({
    required this.title,
    required this.image,
    required this.categoryId,
    required this.subcategoryId,
  });
}

// Sample products
final List<Product> products = [
  Product(
    title: "iPhone 15",
    image: "assets/images/image1.png",
    categoryId: "electronics",
    subcategoryId: "mobiles",
  ),
  Product(
    title: "MacBook Pro",
    image: "assets/images/image1.png",
    categoryId: "electronics",
    subcategoryId: "laptops",
  ),
  Product(
    title: "Headphones",
    image: "assets/images/image1.png",
    categoryId: "electronics",
    subcategoryId: "headphones",
  ),
  Product(
    title: "Nike Shoes",
    image: "assets/images/image1.png",
    categoryId: "fashion",
    subcategoryId: "shoes",
  ),
  Product(
    title: "Backpack",
    image: "assets/images/image1.png",
    categoryId: "fashion",
    subcategoryId: "bags",
  ),
  Product(
    title: "Smart Watch",
    image: "assets/images/image1.png",
    categoryId: "electronics",
    subcategoryId: "accessories",
  ),
];
