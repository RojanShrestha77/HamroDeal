import 'package:flutter/material.dart';

class ThemeState {
  final ThemeMode themeMode;
  final bool isAutoMode;
  final bool hasLightSensor;

  const ThemeState({
    this.themeMode = ThemeMode.system,
    this.isAutoMode = false,
    this.hasLightSensor = true,
  });

  ThemeState copyWith({
    ThemeMode? themeMode,
    bool? isAutoMode,
    bool? hasLightSensor,
  }) {
    return ThemeState(
      themeMode: themeMode ?? this.themeMode,
      isAutoMode: isAutoMode ?? this.isAutoMode,
      hasLightSensor: hasLightSensor ?? this.hasLightSensor,
    );
  }
}
