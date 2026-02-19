import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hamro_deal/app/theme/app_theme.dart';
import 'package:hamro_deal/app/theme/theme_view_model.dart';
import 'package:hamro_deal/screens/splash_screen.dart';
import 'package:hamro_deal/theme/theme_data.dart';

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeState = ref.watch(themeViewModelProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hamro Deal',
      // theme: getApplicationTheme(),
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeState.themeMode,
      home: SplashScreen(),
    );
  }
}
