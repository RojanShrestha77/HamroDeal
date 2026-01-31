import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hamro_deal/features/product/domain/entities/product_entity.dart';
import 'package:hamro_deal/features/product/presentation/page/product_detail_page.dart';
import 'package:hamro_deal/features/product/presentation/state/product_state.dart';
import 'package:hamro_deal/features/product/presentation/view_model/product_view_model.dart';
import 'package:hamro_deal/screens/bottom_screen/search_screen.dart';
import 'package:hamro_deal/widgets/vertical_product_card.dart';
import 'package:hamro_deal/widgets/horizontal_product_card.dart';
import 'package:hamro_deal/models/product_model.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // load the products when screen opens
    Future.microtask(() {
      ref.read(productViewModelProvider.notifier).getAllProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final productState = ref.watch(productViewModelProvider);
    final products = productState.products;

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await ref.read(productViewModelProvider.notifier).getAllProducts();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Search Bar
                  _buildSearchBar(context),

                  const SizedBox(height: 24),

                  // propduct recommendation section
                  _buildRecommendedSection(products),

                  const SizedBox(height: 30),

                  // shop now banner
                  _buildShopNowBanner(),

                  const SizedBox(height: 15),
                  // Vertical GridView
                  _buildProductsGrid(productState, products),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRecommendedSection(List<ProductEntity> products) {
    final recommendedProducts = products.take(6).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            "Recommended For You",
            style: TextStyle(fontSize: 20, fontFamily: 'Just Bold'),
          ),
        ),
        const SizedBox(height: 16),

        recommendedProducts.isEmpty
            ? const Center(
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: Text('No products available'),
                ),
              )
            : SizedBox(
                height: 300,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  scrollDirection: Axis.horizontal,
                  itemCount: recommendedProducts.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (_, index) {
                    final product = recommendedProducts[index];
                    return HorizontalProductCard(
                      product: product,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ProductDetailPage(product: product),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
      ],
    );
  }

  // shop now banner
  Widget _buildShopNowBanner() {
    return Container(
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
          fontFamily: 'Just Bold',
        ),
      ),
    );
  }

  //products grid
  Widget _buildProductsGrid(
    ProductState productState,
    List<ProductEntity> products,
  ) {
    if (productState.status == ProductStatus.loading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: CircularProgressIndicator(),
        ),
      );
    }
    // Error State
    if (productState.status == ProductStatus.error) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
              const SizedBox(height: 16),
              Text(
                productState.errorMessage ?? "Failed to load Message",
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  ref.read(productViewModelProvider.notifier).getAllProducts();
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }
    if (products.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            children: [
              Icon(
                Icons.inventory_2_outlined,
                size: 64,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 16),
              const Text(
                'No productsd available yet',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      );
    }

    // products grid
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
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
          product: product,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ProductDetailPage(product: product),
              ),
            );
          },
        );
      },
    );
  }
}

Widget _buildSearchBar(BuildContext context) {
  return GestureDetector(
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
          Text("Search", style: TextStyle(color: Colors.black, fontSize: 18)),
        ],
      ),
    ),
  );
}
