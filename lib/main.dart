import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hamro_deal/app/app.dart';
import 'package:hamro_deal/core/api/api_client.dart';
import 'package:hamro_deal/core/api/api_endpoints.dart';
import 'package:hamro_deal/core/services/hive/hive_service.dart';
import 'package:hamro_deal/core/services/storage/user_session_service.dart';
import 'package:hamro_deal/core/utils/deep_link_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Global navigator key for deep linking
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Resolve the correct API base URL once at startup.
  // Automatically picks your PC's IP for physical devices
  // and 10.0.2.2 for the Android emulator.
  final baseUrl = await ApiEndpoints.resolveBaseUrl();
  final serverUrl = await ApiEndpoints.resolveServerUrl();

  // Set the static serverUrl used by image URL helpers (productImage, etc.)
  ApiEndpoints.serverUrl = serverUrl;

  final hiveService = HiveService();
  await hiveService.init();

  final sharedPrefs = await SharedPreferences.getInstance();

  // Initialize deep link handler
  final deepLinkHandler = DeepLinkHandler(navigatorKey);
  deepLinkHandler.initialize();

  runApp(
    ProviderScope(
      overrides: [
        SharedPreferencesProvider.overrideWithValue(sharedPrefs),
        resolvedBaseUrlProvider.overrideWithValue(baseUrl),
      ],
      child: MyApp(),
    ),
  );
}
