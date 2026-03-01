// hamro_deal/lib/core/utils/deep_link_handler.dart
import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:hamro_deal/features/auth/presentation/pages/reset_password_page.dart';

class DeepLinkHandler {
  final AppLinks _appLinks = AppLinks();
  final GlobalKey<NavigatorState> navigatorKey;

  DeepLinkHandler(this.navigatorKey);

  Future<void> initialize() async {
    // Handle initial link if app was opened from a deep link
    final initialUri = await _appLinks.getInitialLink();
    if (initialUri != null) {
      _handleDeepLink(initialUri);
    }

    // Listen for deep links while app is running
    _appLinks.uriLinkStream.listen(
      (Uri uri) {
        _handleDeepLink(uri);
      },
      onError: (err) {
        print('Deep link error: $err');
      },
    );
  }

  void _handleDeepLink(Uri uri) {
    print('Deep link received: $uri');
    print('Host: ${uri.host}, Path: ${uri.path}');

    // Handle reset-password deep link
    // Supports both hamrodeal://reset-password?token=xxx
    if (uri.host == 'reset-password' || uri.path.contains('reset-password')) {
      final token = uri.queryParameters['token'];
      if (token != null && token.isNotEmpty) {
        _navigateToResetPassword(token);
      } else {
        print('No token found in deep link');
      }
    }
  }

  void _navigateToResetPassword(String token) {
    final context = navigatorKey.currentContext;
    if (context != null) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ResetPasswordPage(token: token),
        ),
      );
    }
  }
}
