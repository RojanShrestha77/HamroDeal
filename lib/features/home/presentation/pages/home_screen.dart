import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'dart:async';
import 'package:hamro_deal/core/api/api_client.dart';
import 'package:hamro_deal/core/api/api_endpoints.dart';
import 'package:hamro_deal/core/utils/snakbar_utils.dart';
import 'package:hamro_deal/features/auth/presentation/view_model/auth_view_model.dart';
import 'package:hamro_deal/features/category/presentation/view_model/category_viewmodel.dart';
import 'package:hamro_deal/features/notification/presentation/widgets/notification_icon_button.dart';
import 'package:hamro_deal/features/product/data/models/product_api_model.dart';
import 'package:hamro_deal/features/product/domain/entities/product_entity.dart';
import 'package:hamro_deal/features/product/presentation/page/porduct_browse_screen.dart';
import 'package:hamro_deal/features/product/presentation/page/product_detail_page.dart';
import 'package:hamro_deal/features/product/presentation/state/product_state.dart';
import 'package:hamro_deal/features/product/presentation/view_model/product_browse_view_model.dart';
import 'package:hamro_deal/features/product/presentation/view_model/product_view_model.dart';
import 'package:hamro_deal/features/search/presentation/pages/search_screen.dart';
import 'package:hamro_deal/features/home/presentation/widgets/vertical_product_card.dart';
import 'package:hamro_deal/features/home/presentation/widgets/horizontal_product_card.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  List<ProductEntity> _newestProducts = [];
  List<ProductEntity> _trendingProducts = [];
  int _selectedCategoryIndex = -1;
  bool _isLoadingSpecial = false;

  // Shake detector using sensors_plus
  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;
  bool _isRefreshing = false;
  DateTime? _lastShakeTime;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(productViewModelProvider.notifier).getAllProducts();
      ref.read(categoryViewModelProvider.notifier).getAllCategories();
      _loadSpecialProducts();
    });
    _initializeShakeDetector();
  }

  void _initializeShakeDetector() {
    _accelerometerSubscription = accelerometerEvents.listen((
      AccelerometerEvent event,
    ) {
      final now = DateTime.now();

      // Check if enough time has passed since last shake
      if (_lastShakeTime != null &&
          now.difference(_lastShakeTime!).inSeconds < 3) {
        return;
      }

      // Calculate shake intensity
      final gForce = event.x.abs() + event.y.abs() + event.z.abs();

      // If shake is strong enough (threshold: 25)
      if (gForce > 25) {
        _lastShakeTime = now;
        _handleShakeRefresh();
      }
    });
  }

  void _handleShakeRefresh() {
    if (_isRefreshing) return;

    setState(() {
      _isRefreshing = true;
    });

    HapticFeedback.mediumImpact();

    if (mounted) {
      SnackbarUtils.showInfo(context, '🔄 Refreshing products...');
    }

    Future.wait([
          ref.read(productViewModelProvider.notifier).getAllProducts(),
          _loadSpecialProducts(),
        ])
        .then((_) {
          if (mounted) {
            setState(() {
              _isRefreshing = false;
            });
            HapticFeedback.lightImpact();
            SnackbarUtils.showSuccess(context, '✅ Products refreshed!');
          }
        })
        .catchError((error) {
          if (mounted) {
            setState(() {
              _isRefreshing = false;
            });
            SnackbarUtils.showError(context, 'Failed to refresh products');
          }
        });
  }

  @override
  void dispose() {
    _accelerometerSubscription?.cancel();
    super.dispose();
  }

  Future<void> _loadSpecialProducts() async {
    setState(() {
      _isLoadingSpecial = true;
    });

    try {
      final apiClient = ref.read(apiClientProvider);

      // Fetch newest products
      try {
        final newestResponse = await apiClient.get(ApiEndpoints.newestProducts);

        if (newestResponse.data['success'] == true) {
          final newestData = newestResponse.data['data'] as List;
          _newestProducts = newestData
              .map((json) => ProductApiModel.fromJson(json).toEntity())
              .toList();
        }
      } catch (e) {
        print('Error loading newest products: $e');
      }

      // Fetch trending products
      try {
        final trendingResponse = await apiClient.get(
          ApiEndpoints.trendingProducts,
        );
        print('Trending response: ${trendingResponse.data}');

        if (trendingResponse.data['success'] == true) {
          final trendingData = trendingResponse.data['data'] as List;
          _trendingProducts = trendingData
              .map((json) => ProductApiModel.fromJson(json).toEntity())
              .toList();
        }
      } catch (e) {
        print('Error loading trending products: $e');
      }

      setState(() {
        _isLoadingSpecial = false;
      });
    } catch (e) {
      print('Error loading special products: $e');
      setState(() {
        _isLoadingSpecial = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final productState = ref.watch(productViewModelProvider);
    final products = productState.products;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 80,
        title: _buildUserProfileHeader(),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await ref.read(productViewModelProvider.notifier).getAllProducts();
            await _loadSpecialProducts();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_isRefreshing)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      margin: const EdgeInsets.only(bottom: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.black,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'Refreshing...',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),

                  // Search Bar
                  _buildSearchBar(context),

                  const SizedBox(height: 24),

                  _buildCategoriesSection(),

                  const SizedBox(height: 24),

                  // Newest Products Section
                  _buildProductSection(
                    title: "Newest Products",
                    products: _newestProducts,
                    isLoading: _isLoadingSpecial,
                  ),

                  const SizedBox(height: 50),

                  // Trending Products Section
                  _buildProductSection(
                    title: "Trending Now",
                    products: _trendingProducts,
                    isLoading: _isLoadingSpecial,
                  ),

                  const SizedBox(height: 40),

                  // shop now banner
                  _buildShopNowBanner(),

                  const SizedBox(height: 15),

                  // All Products Grid
                  _buildProductsGrid(productState, products),

                  const SizedBox(height: 100), // Extra space to clear the floating bottom nav
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUserProfileHeader() {
    final authState = ref.watch(authViewModelProvider);
    final user = authState.authEntity;

    return Row(
      children: [
        // User Profile Image
        if (user?.imageUrl != null)
          CircleAvatar(
            radius: 25,
            backgroundImage: NetworkImage(
              ApiEndpoints.userProfileImage(user!.imageUrl!),
            ),
            backgroundColor: Colors.grey[300],
          )
        else
          CircleAvatar(
            radius: 25,
            backgroundColor: Colors.grey[300],
            child: Icon(Icons.person, color: Colors.grey[600], size: 28),
          ),

        const SizedBox(width: 12),

        // Greeting Text
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Hello ${user?.firstName ?? 'User'} ${user?.lastName ?? ''}',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                  fontWeight: FontWeight.normal,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              const Text(
                'Welcome Back!',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Just Bold',
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),

        // Notification Icon
        const NotificationIconButton(),
      ],
    );
  }

  Widget _buildCategoriesSection() {
    final categoryState = ref.watch(categoryViewModelProvider);
    final categories = categoryState.categories;
    if (categories.isEmpty) {
      return const SizedBox.shrink();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 115,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            separatorBuilder: (_, __) => const SizedBox(width: 20),
            itemBuilder: (_, index) {
              final category = categories[index];
              return _buildCategoryCard(category, index);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryCard(dynamic category, int index) {
    final isSelected = _selectedCategoryIndex == index;

    return GestureDetector(
      onTapDown: (_) => setState(() => _selectedCategoryIndex = index),
      onTapCancel: () => setState(() => _selectedCategoryIndex = -1),
      onTap: () {
        Future.delayed(const Duration(milliseconds: 200), () {
          if (mounted) {
            setState(() => _selectedCategoryIndex = -1);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const PorductBrowseScreen()),
            );
            ref
                .read(productBrowseViewModelProvider.notifier)
                .selectCategory(category.categoryId);
          }
        });
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: isSelected ? Colors.black : Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(isSelected ? 0.25 : 0.08),
                  blurRadius: isSelected ? 20 : 15,
                  spreadRadius: isSelected ? 3 : 2,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              _getCategoryIcon(category.name),
              color: isSelected ? Colors.white : const Color(0xFF333333),
              size: 32,
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: 75,
            child: Text(
              category.name,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.black : Colors.grey[600],
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getCategoryIcon(String categoryName) {
    final name = categoryName.toLowerCase();
    if (name.contains('electronic') || name.contains('tech')) {
      return Icons.devices_outlined;
    } else if (name.contains('fashion') || name.contains('cloth')) {
      return Icons.checkroom_outlined;
    } else if (name.contains('furniture')) {
      return Icons.chair_outlined;
    } else if (name.contains('home') || name.contains('living')) {
      return Icons.other_houses_outlined;
    } else if (name.contains('beauty') || name.contains('cosmetic')) {
      return Icons.face_outlined;
    } else if (name.contains('toy')) {
      return Icons.toys_outlined;
    } else if (name.contains('footwear') || name.contains('shoe')) {
      return Icons.shopping_bag_outlined;
    } else if (name.contains('jewel') || name.contains('jewelry')) {
      return Icons.diamond_outlined;
    } else if (name.contains('sport') || name.contains('fitness')) {
      return Icons.sports_soccer_outlined;
    } else if (name.contains('book')) {
      return Icons.menu_book_outlined;
    } else if (name.contains('food') || name.contains('grocery')) {
      return Icons.restaurant_outlined;
    } else {
      return Icons.category_outlined;
    }
  }

  Widget _buildProductSection({
    required String title,
    required List<ProductEntity> products,
    required bool isLoading,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              fontFamily: 'Just Bold',
            ),
          ),
        ),
        const SizedBox(height: 16),

        if (isLoading)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(32),
              child: CircularProgressIndicator(),
            ),
          )
        else if (products.isEmpty)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(32),
              child: Text('No products available'),
            ),
          )
        else
          SizedBox(
            height: 360, // Increased from 350 to provide more vertical space for tags/buttons
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: products.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (_, index) {
                final product = products[index];
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

    if (productState.status == ProductStatus.error) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
              const SizedBox(height: 16),
              Text(
                productState.errorMessage ?? "Failed to load products",
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
                'No products available yet',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: products.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.48, // Balanced for typical phone screens to prevent overflows
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
      height: 52,
      decoration: BoxDecoration(
        color: const Color(0xFFEEEEEE),
        borderRadius: BorderRadius.circular(100),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(Icons.search, color: Colors.grey[600], size: 22),
          const SizedBox(width: 10),
          Text(
            "What do you need?",
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 15,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    ),
  );
}
