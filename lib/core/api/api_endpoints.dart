import 'dart:io';
import 'package:flutter/foundation.dart';

class ApiEndpoints {
  ApiEndpoints._();

  // Configuration
  static const bool isPhysicalDevice = false;
  static const String _ipAddress = '192.168.1.1';
  static const int _port = 5050;

  // Base URLs
  static String get _host {
    if (isPhysicalDevice) return _ipAddress;
    if (kIsWeb || Platform.isIOS) return 'localhost';
    if (Platform.isAndroid) return '10.0.2.2';
    return 'localhost';
  }

  static String get serverUrl => 'http://$_host:$_port';
  static String get baseUrl => '$serverUrl/api';
  static String get mediaServerUrl => serverUrl;

  // Timeouts
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // ====== Auth Endpoints (was Student) =========
  static const String register = '/auth/register';
  static const String login = '/auth/login';
  static const String whoami = '/auth/whoami';
  static const String updateProfile = '/auth/update-profile';
  static const String requestPasswordReset = '/auth/request-password-reset';
  static String resetPassword(String token) => '/auth/reset-password/$token';

  // ====== Category Endpoints ======
  static const String categories = '/categories';
  static String categoryById(String id) => '/categories/$id';

  // ======= Product Endpoints (was Items) =========
  static const String products = '/products';
  static String productById(String id) => '/products/$id';
  static const String searchProducts = '/products/search';
  static const String productsByCategory = '/products/category';
  static const String myProducts = '/products/my-products';
  // static const String productUploadImage = '/products/upload-image';

  // ========= Cart Endpoints (NEW) =========
  static const String cart = '/cart';
  static String updateCartItem(String productId) => '/cart/$productId';
  static String removeFromCart(String productId) => '/cart/$productId';
  static const String clearCart = '/cart/clear/all';

  // ========= Wishlist Endpoints (NEW) =========
  static const String wishlist = '/wishlist';
  static String addToWishlist(String productId) => '/wishlist/$productId';
  static String removeFromWishlist(String productId) => '/wishlist/$productId';

  // ========= Order Endpoints (NEW) =========
  static const String orders = '/orders';
  static String orderById(String id) => '/orders/$id';
  static String cancelOrder(String id) => '/orders/$id/cancel';

  // ========= Blog Endpoints (NEW) =========
  static const String blogs = '/blogs';
  static String blogById(String id) => '/blogs/$id';

  // ==================== Media Helper Methods ==================
  static String productImage(String filename) {
    // Backend returns /uploads/filename, so just append to server URL
    if (filename.startsWith('/')) {
      return '$mediaServerUrl$filename';
    }
    // Fallback for just filename
    return '$mediaServerUrl/uploads/$filename';
  }

  static String categoryImage(String filename) =>
      '$mediaServerUrl/uploads/$filename';

  static String userProfileImage(String filename) {
    if (filename.startsWith('/')) {
      return '$mediaServerUrl$filename';
    }
    return '$mediaServerUrl/uploads/$filename';
  }
}
