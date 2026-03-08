import 'dart:io';
import 'package:flutter/foundation.dart';

class ApiEndpoints {
  ApiEndpoints._();

  // Your PC's local network IP address.
  // Run `ipconfig` (Windows) or `ifconfig` (Mac/Linux) to find it.
  static const String _physicalDeviceIp = '192.168.10.2';
  static const int _port = 5050;

  /// Called ONCE at app startup in main.dart.
  /// Returns the correct base URL for the current device.
  static Future<String> resolveBaseUrl() async {
    final host = await _resolveHost();
    return 'http://$host:$_port/api';
  }

  static Future<String> resolveServerUrl() async {
    final host = await _resolveHost();
    return 'http://$host:$_port';
  }

  // Set once at startup by main.dart — used by image helper methods below.
  static String serverUrl = 'http://localhost:$_port';

  // Detects at runtime: physical device gets your PC's IP,
  // emulator gets the Android emulator loopback (10.0.2.2).
  // Uses simple heuristic: try to connect to 10.0.2.2 (emulator) first.
  static Future<String> _resolveHost() async {
    if (kIsWeb || Platform.isIOS) return 'localhost';
    if (Platform.isAndroid) {
      // Try emulator first (10.0.2.2)
      try {
        final socket = await Socket.connect('10.0.2.2', _port,
            timeout: const Duration(seconds: 2));
        socket.destroy();
        return '10.0.2.2'; // Emulator detected
      } catch (e) {
        return _physicalDeviceIp; // Physical device
      }
    }
    return 'localhost';
  }

  // Timeouts
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // ====== Auth Endpoints  =========
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
  static const String newestProducts = '/products/newest';
  static const String trendingProducts = '/products/trending';

  // ========= Cart Endpoints =========
  static const String cart = '/cart';
  static String updateCartItem(String productId) => '/cart/$productId';
  static String removeFromCart(String productId) => '/cart/$productId';
  static const String clearCart = '/cart/clear/all';

  // ========= Wishlist Endpoints =========
  static const String wishlist = '/wishlist';
  static String addToWishlist(String productId) => '/wishlist/$productId';
  static String removeFromWishlist(String productId) => '/wishlist/$productId';

  // ========= Order Endpoints =========
  static const String orders = '/orders';
  static String orderById(String id) => '/orders/$id';
  static String cancelOrder(String id) => '/orders/$id/cancel';
  static const String myOrders = '/orders/my-orders';
  
  // ========= Seller Order Endpoints =========
  static const String sellerOrders = '/seller/orders';
  static String sellerOrderById(String id) => '/seller/orders/$id';
  static String updateSellerOrderStatus(String id) => '/seller/orders/$id/status';

  // ========= Blog Endpoints =========
  static const String blogs = '/blogs';
  static String blogById(String id) => '/blogs/$id';

  // ======== admin order endpoints ================
  static const String adminOrders = '/admin/orders';
  static String adminOrderById(String id) => '/admin/orders/$id';
  static String adminUpdateOrderStatus(String id) => '/admin/orders/$id/status';
  static String adminDeleteOrder(String id) => '/admin/orders/$id';

  // ======== admin user endpoints ================
  static const String adminUsers = '/admin/users';
  static String adminUserById(String id) => '/admin/users/$id';
  static String adminUserDetails(String id) => '/admin/users/$id/details';
  static String adminUpdateUser(String id) => '/admin/users/$id';
  static String adminDeleteUser(String id) => '/admin/users/$id';
  static String adminApproveSeller(String id) =>
      '/admin/users/$id/approve-seller';

  // ================ admin analytics endpoints =============
  static const String adminAnalyticsOverview = '/admin/analytics/overview';
  static const String adminAnalyticsRevenue = '/admin/analytics/revenue';
  static const String adminAnalyticsTopProducts =
      '/admin/analytics/top-products';
  static const String adminAnalyticsRecentOrders =
      '/admin/analytics/recent-orders';
  static const String adminAnalyticsLowStock = '/admin/analytics/low-stock';
  static const String adminAnalyticsTopSellers = '/admin/analytics/top-sellers';

  // ========= Review Endpoints =========
  static const String reviews = '/reviews';
  static String productReviews(String productId) =>
      '/reviews/product/$productId';
  static String createReview(String productId) => '/reviews/product/$productId';
  static const String myReviews = '/reviews/my-reviews';
  static String updateReview(String reviewId) => '/reviews/$reviewId';
  static String deleteReview(String reviewId) => '/reviews/$reviewId';

  // ========= Notification Endpoints =========
  static const String notifications = '/notifications';
  static const String notificationsUnreadCount = '/notifications/unread-count';
  static const String notificationsMarkAllRead = '/notifications/mark-all-read';
  static String notificationById(String id) => '/notifications/$id';
  static String markNotificationAsRead(String id) => '/notifications/$id/read';
  static String deleteNotification(String id) => '/notifications/$id';

  // ========= Messaging Endpoints =========
  static const String conversations = '/conversations';
  static String conversationById(String id) => '/conversations/$id';
  static String deleteConversation(String id) => '/conversations/$id';
  static String resetUnreadCount(String id) => '/conversations/$id/read';
  static const String createOrGetConversation = '/conversations';

  static const String messages = '/messages';
  static String messagesByConversation(String conversationId) =>
      '/messages/conversation/$conversationId';
  static String deleteMessage(String id) => '/messages/$id';
  static String markMessagesAsRead(String conversationId) =>
      '/messages/conversation/$conversationId/read';

  // ==================== Media Helper Methods ==================
  static String productImage(String filename) {
    if (filename.startsWith('/')) {
      return '$serverUrl$filename';
    }
    return '$serverUrl/uploads/$filename';
  }

  static String categoryImage(String filename) =>
      '$serverUrl/uploads/$filename';

  static String userProfileImage(String filename) {
    if (filename.startsWith('/')) {
      return '$serverUrl$filename';
    }
    return '$serverUrl/uploads/$filename';
  }
}
