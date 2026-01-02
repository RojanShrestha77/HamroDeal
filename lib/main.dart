// main.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hamro_deal/app.dart'; // Your MyApp widget
import 'package:hamro_deal/core/services/hive_service.dart';

Future<void> main() async {
  // Ensure Flutter is initialized before any async calls
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive (register adapters & open boxes)
  final hiveService = HiveService();
  await hiveService.init();

  // Optionally, you can check if a user is already logged in here
  // final currentUser = await hiveService.getCurrentUser();

  // Run the app wrapped in Riverpod ProviderScope
  runApp(const ProviderScope(child: MyApp()));
}
