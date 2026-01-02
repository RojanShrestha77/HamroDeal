// main.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hamro_deal/app.dart'; // Your MyApp widget
import 'package:hamro_deal/core/services/hive_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final hiveService = HiveService();
  await hiveService.init();

  runApp(const ProviderScope(child: MyApp()));
}
