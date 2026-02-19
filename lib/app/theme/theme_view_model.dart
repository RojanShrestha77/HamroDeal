import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'theme_state.dart';

final themeViewModelProvider = NotifierProvider<ThemeViewModel, ThemeState>(
  () => ThemeViewModel(),
);

class ThemeViewModel extends Notifier<ThemeState> {
  static const String _themeKey = 'theme_mode';

  @override
  ThemeState build() {
    _loadTheme();
    return const ThemeState();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final themeModeString = prefs.getString(_themeKey);

    if (themeModeString != null) {
      final themeMode = ThemeMode.values.firstWhere(
        (mode) => mode.toString() == themeModeString,
        orElse: () => ThemeMode.system,
      );
      state = ThemeState(themeMode: themeMode);
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = ThemeState(themeMode: mode);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeKey, mode.toString());
  }

  void toggleTheme() {
    if (state.themeMode == ThemeMode.light) {
      setThemeMode(ThemeMode.dark);
    } else {
      setThemeMode(ThemeMode.light);
    }
  }
}
