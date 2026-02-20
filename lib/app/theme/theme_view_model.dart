import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:light/light.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'theme_state.dart';

final themeViewModelProvider = NotifierProvider<ThemeViewModel, ThemeState>(
  () => ThemeViewModel(),
);

class ThemeViewModel extends Notifier<ThemeState> {
  static const String _themeModeKey = 'theme_mode';
  static const String _autoModeKey = 'auto_mode';
  static const int _lightThreshold = 100; // lux

  Light? _light;
  StreamSubscription? _lightSubscription;

  @override
  ThemeState build() {
    _loadTheme();

    // Cleanup when provider is disposed
    ref.onDispose(() {
      _lightSubscription?.cancel();
    });

    return const ThemeState();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final themeModeString = prefs.getString(_themeModeKey);
    final isAutoMode = prefs.getBool(_autoModeKey) ?? false;

    ThemeMode themeMode = ThemeMode.system;
    if (themeModeString != null) {
      themeMode = ThemeMode.values.firstWhere(
        (mode) => mode.toString() == themeModeString,
        orElse: () => ThemeMode.system,
      );
    }

    state = ThemeState(themeMode: themeMode, isAutoMode: isAutoMode);

    if (isAutoMode) {
      await _startLightSensor();
    }
  }

  Future<void> setLightMode() async {
    await _stopLightSensor();
    state = state.copyWith(themeMode: ThemeMode.light, isAutoMode: false);
    await _saveTheme();
  }

  Future<void> setDarkMode() async {
    await _stopLightSensor();
    state = state.copyWith(themeMode: ThemeMode.dark, isAutoMode: false);
    await _saveTheme();
  }

  Future<void> enableAutoMode() async {
    final success = await _startLightSensor();
    if (success) {
      state = state.copyWith(isAutoMode: true, hasLightSensor: true);
      await _saveTheme();
    } else {
      state = state.copyWith(hasLightSensor: false);
    }
  }

  Future<bool> _startLightSensor() async {
    try {
      _light = Light();
      _lightSubscription = _light!.lightSensorStream.listen((lux) {
        final newThemeMode = lux > _lightThreshold
            ? ThemeMode.light
            : ThemeMode.dark;

        if (state.themeMode != newThemeMode) {
          state = state.copyWith(themeMode: newThemeMode);
        }
      });
      return true;
    } catch (e) {
      debugPrint('Light sensor not available: $e');
      return false;
    }
  }

  Future<void> _stopLightSensor() async {
    await _lightSubscription?.cancel();
    _lightSubscription = null;
    _light = null;
  }

  Future<void> _saveTheme() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeModeKey, state.themeMode.toString());
    await prefs.setBool(_autoModeKey, state.isAutoMode);
  }

  void toggleTheme() {
    if (state.themeMode == ThemeMode.light) {
      setDarkMode();
    } else {
      setLightMode();
    }
  }
}
