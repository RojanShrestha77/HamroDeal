import 'dart:io';
import 'package:flutter/foundation.dart';

class ApiEndpoints {
  ApiEndpoints._();

  // Configuration
  static const bool isPhysicalDevice = false;
  static const String _ipAddress = '192.168.1.1';
  static const int _port = 3000;

  // Base URLs
  static String get _host {
    if (isPhysicalDevice) return _ipAddress;
    if (kIsWeb || Platform.isIOS) return 'localhost';
    if (Platform.isAndroid) return '10.0.2.2';
    return 'localhost';
  }

  static String get serverUrl => 'http://$_host:$_port';
  static String get baseUrl => '$serverUrl/api/v1';
  static String get mediaServerUrl => serverUrl; // ✅ This is the key!

  // Timeouts
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // ====== Batch Endpoints =========
  static const String batches = '/batches';
  static String batchById(String id) => '/batches/$id';

  // ====== Category Endpoints ======
  static const String categories = '/categories';
  static String categoryById(String id) => '/categories/$id';

  // ======== Student Endpoints ========
  static const String students = '/students';
  static const String studentLogin = '/students/login';
  static const String studentRegister = '/students/register';
  static String studentById(String id) => '/students/$id';
  static String studentPhoto(String id) => '/students/$id/photo';

  // ============== Profile Picture ==============
  static const String uploadProfilePicture = '/students/upload-profile-picture';

  // ======= Item/Product Endpoints =========
  static const String items = '/items';
  static String itemById(String id) => '/items/$id';
  static String itemClaim(String id) => '/items/$id/claim';
  static const String itemUploadPhoto = '/items/upload-photo';
  static const String itemUploadVideo = '/items/upload-video';

  // ========= Comment Endpoints =========
  static const String comments = '/comments';
  static String commentById(String id) => '/comments/$id';
  static String commentsByItem(String itemId) => '/comments/items/$itemId';
  static String commentLike(String id) => '/comments/$id/like';

  // ==================== Media Helper Methods ==================
  static String itemPicture(String filename) =>
      '$mediaServerUrl/item_photos/$filename';

  static String itemVideo(String filename) =>
      '$mediaServerUrl/item_videos/$filename';

  static String categoryPicture(String filename) =>
      '$mediaServerUrl/categories/$filename';

  static String studentPicture(String filename) =>
      '$mediaServerUrl/profile_pictures/$filename';
}
