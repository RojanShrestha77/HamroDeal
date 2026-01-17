import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hamro_deal/app.dart';
import 'package:hamro_deal/core/services/hive/hive_service.dart';
import 'package:hamro_deal/core/services/storage/user_session_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final hiveService = HiveService();
  await hiveService.init();

  final sharedPrefs = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [SharedPreferencesProvider.overrideWithValue(sharedPrefs)],
      child: MyApp(),
    ),
  );
}
