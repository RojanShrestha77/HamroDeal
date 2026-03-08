import 'package:flutter/material.dart';

class ResponsiveUtils {
  /// Get responsive grid columns based on screen width
  /// Mobile: 2 columns
  /// Tablet: 3-4 columns
  /// Desktop: 4-5 columns
  static int getGridColumns(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    if (screenWidth < 600) {
      return 2; // Mobile
    } else if (screenWidth < 900) {
      return 3; // Small tablet
    } else if (screenWidth < 1200) {
      return 4; // Medium tablet
    } else {
      return 5; // Large tablet/desktop
    }
  }

  /// Get responsive child aspect ratio for grid items
  /// Maintains good proportions across all screen sizes
  static double getGridChildAspectRatio(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    if (screenWidth < 600) {
      return 0.48; // Mobile - taller cards
    } else if (screenWidth < 900) {
      return 0.55; // Small tablet
    } else {
      return 0.60; // Larger screens
    }
  }

  /// Get responsive icon size
  static double getIconSize(BuildContext context, {double mobileSize = 22}) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    if (screenWidth < 600) {
      return mobileSize;
    } else if (screenWidth < 900) {
      return mobileSize * 1.2;
    } else {
      return mobileSize * 1.4;
    }
  }

  /// Get responsive padding
  static EdgeInsets getResponsivePadding(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    if (screenWidth < 600) {
      return const EdgeInsets.all(16);
    } else if (screenWidth < 900) {
      return const EdgeInsets.all(20);
    } else {
      return const EdgeInsets.all(24);
    }
  }

  /// Get responsive spacing
  static double getResponsiveSpacing(BuildContext context, {double mobileSpacing = 12}) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    if (screenWidth < 600) {
      return mobileSpacing;
    } else if (screenWidth < 900) {
      return mobileSpacing * 1.2;
    } else {
      return mobileSpacing * 1.5;
    }
  }
}
