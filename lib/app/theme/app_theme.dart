// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'app_colors.dart';

// class AppTheme {
//   static ThemeData get lightTheme {
//     return ThemeData(
//       useMaterial3: true,
//       fontFamily: 'Inter',
//       colorScheme: ColorScheme.fromSeed(
//         seedColor: AppColors.primary,
//         brightness: Brightness.light,
//       ),
//       scaffoldBackgroundColor: AppColors.background,

//       // AppBar Theme
//       appBarTheme: const AppBarTheme(
//         elevation: 0,
//         centerTitle: true,
//         backgroundColor: Colors.transparent,
//         systemOverlayStyle: SystemUiOverlayStyle.dark,
//         iconTheme: IconThemeData(color: AppColors.textPrimary),
//         titleTextStyle: TextStyle(
//           fontFamily: 'Inter',
//           color: AppColors.textPrimary,
//           fontSize: 20,
//           fontWeight: FontWeight.w600,
//         ),
//       ),

//       // Input Decoration Theme
//       inputDecorationTheme: InputDecorationTheme(
//         filled: true,
//         fillColor: Colors.white,
//         contentPadding: const EdgeInsets.symmetric(
//           horizontal: 20,
//           vertical: 16,
//         ),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(16),
//           borderSide: BorderSide(color: AppColors.border, width: 1),
//         ),
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(16),
//           borderSide: BorderSide(color: AppColors.border, width: 1),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(16),
//           borderSide: const BorderSide(color: AppColors.primary, width: 2),
//         ),
//         errorBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(16),
//           borderSide: const BorderSide(color: AppColors.error, width: 1),
//         ),
//         focusedErrorBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(16),
//           borderSide: const BorderSide(color: AppColors.error, width: 2),
//         ),
//         labelStyle: const TextStyle(
//           fontFamily: 'Inter',
//           color: AppColors.textSecondary,
//           fontSize: 14,
//           fontWeight: FontWeight.w500,
//         ),
//         hintStyle: const TextStyle(
//           fontFamily: 'Inter',
//           color: Color(0x996B7280), // textSecondary with 60% opacity
//           fontSize: 14,
//         ),
//       ),

//       // Elevated Button Theme
//       elevatedButtonTheme: ElevatedButtonThemeData(
//         style: ElevatedButton.styleFrom(
//           elevation: 0,
//           padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(16),
//           ),
//           textStyle: const TextStyle(
//             fontFamily: 'Inter',
//             fontSize: 16,
//             fontWeight: FontWeight.w600,
//             letterSpacing: 0.5,
//           ),
//         ),
//       ),

//       // Text Button Theme
//       textButtonTheme: TextButtonThemeData(
//         style: TextButton.styleFrom(
//           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(12),
//           ),
//           textStyle: const TextStyle(
//             fontFamily: 'Inter',
//             fontSize: 14,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//       ),

//       // Outlined Button Theme
//       outlinedButtonTheme: OutlinedButtonThemeData(
//         style: OutlinedButton.styleFrom(
//           padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
//           side: BorderSide(color: AppColors.border, width: 1.5),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(16),
//           ),
//           textStyle: const TextStyle(
//             fontFamily: 'Inter',
//             fontSize: 14,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//       ),

//       // Card Theme
//       cardTheme: CardThemeData(
//         elevation: 0,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//         color: Colors.white,
//       ),

//       // Checkbox Theme
//       checkboxTheme: CheckboxThemeData(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
//         fillColor: WidgetStateProperty.resolveWith((states) {
//           if (states.contains(WidgetState.selected)) {
//             return AppColors.primary;
//           }
//           return Colors.transparent;
//         }),
//       ),
//     );
//   }

//   static ThemeData get darkTheme {
//     return ThemeData(
//       useMaterial3: true,
//       fontFamily: 'Inter',
//       colorScheme: ColorScheme.fromSeed(
//         seedColor: AppColors.primary,
//         brightness: Brightness.dark,
//         surface: AppColors.darkSurface,
//       ),
//       scaffoldBackgroundColor: AppColors.darkBackground,

//       // AppBar Theme
//       appBarTheme: const AppBarTheme(
//         elevation: 0,
//         centerTitle: true,
//         backgroundColor: Colors.transparent,
//         systemOverlayStyle: SystemUiOverlayStyle.light,
//         iconTheme: IconThemeData(color: AppColors.darkTextPrimary),
//         titleTextStyle: TextStyle(
//           fontFamily: 'Inter',
//           color: AppColors.darkTextPrimary,
//           fontSize: 20,
//           fontWeight: FontWeight.w600,
//         ),
//       ),

//       // Input Decoration Theme
//       inputDecorationTheme: InputDecorationTheme(
//         filled: true,
//         fillColor: AppColors.darkInputFill,
//         contentPadding: const EdgeInsets.symmetric(
//           horizontal: 20,
//           vertical: 16,
//         ),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(16),
//           borderSide: BorderSide(color: AppColors.darkBorder, width: 1),
//         ),
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(16),
//           borderSide: BorderSide(color: AppColors.darkBorder, width: 1),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(16),
//           borderSide: const BorderSide(color: AppColors.primary, width: 2),
//         ),
//         errorBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(16),
//           borderSide: const BorderSide(color: AppColors.error, width: 1),
//         ),
//         focusedErrorBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(16),
//           borderSide: const BorderSide(color: AppColors.error, width: 2),
//         ),
//         labelStyle: const TextStyle(
//           fontFamily: 'Inter',
//           color: AppColors.darkTextSecondary,
//           fontSize: 14,
//           fontWeight: FontWeight.w500,
//         ),
//         hintStyle: const TextStyle(
//           fontFamily: 'Inter',
//           color: AppColors.darkTextTertiary,
//           fontSize: 14,
//         ),
//         // Add text style for input text
//         floatingLabelStyle: const TextStyle(
//           fontFamily: 'Inter',
//           color: AppColors.primary,
//           fontSize: 14,
//           fontWeight: FontWeight.w500,
//         ),
//         // This ensures the text color is visible
//         prefixIconColor: AppColors.darkTextSecondary,
//         suffixIconColor: AppColors.darkTextSecondary,
//       ),

//       // Elevated Button Theme
//       elevatedButtonTheme: ElevatedButtonThemeData(
//         style: ElevatedButton.styleFrom(
//           elevation: 0,
//           backgroundColor: Colors.black.withOpacity(0.5),
//           foregroundColor: Colors.white,
//           padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(16),
//           ),
//           textStyle: const TextStyle(
//             fontFamily: 'Inter',
//             fontSize: 16,
//             fontWeight: FontWeight.w600,
//             letterSpacing: 0.5,
//           ),
//         ),
//       ),

//       // Text Button Theme
//       textButtonTheme: TextButtonThemeData(
//         style: TextButton.styleFrom(
//           foregroundColor: const Color.fromARGB(255, 23, 16, 156),
//           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(12),
//           ),
//           textStyle: const TextStyle(
//             fontFamily: 'Inter',
//             fontSize: 14,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//       ),

//       // Outlined Button Theme
//       outlinedButtonTheme: OutlinedButtonThemeData(
//         style: OutlinedButton.styleFrom(
//           foregroundColor: AppColors.darkTextPrimary,
//           padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
//           side: BorderSide(color: AppColors.darkBorder, width: 1.5),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(16),
//           ),
//           textStyle: const TextStyle(
//             fontFamily: 'Inter',
//             fontSize: 14,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//       ),

//       // Card Theme
//       cardTheme: CardThemeData(
//         elevation: 0,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//         color: AppColors.darkSurface,
//       ),

//       // Checkbox Theme
//       checkboxTheme: CheckboxThemeData(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
//         fillColor: WidgetStateProperty.resolveWith((states) {
//           if (states.contains(WidgetState.selected)) {
//             return AppColors.primary;
//           }
//           return Colors.transparent;
//         }),
//         checkColor: WidgetStateProperty.all(Colors.white),
//         side: const BorderSide(color: AppColors.darkBorder, width: 1.5),
//       ),

//       // Bottom Navigation Bar Theme
//       bottomNavigationBarTheme: const BottomNavigationBarThemeData(
//         backgroundColor: AppColors.darkSurface,
//         selectedItemColor: AppColors.primary,
//         unselectedItemColor: AppColors.darkTextSecondary,
//         type: BottomNavigationBarType.fixed,
//         elevation: 0,
//       ),

//       // Dialog Theme
//       dialogTheme: DialogThemeData(
//         backgroundColor: AppColors.darkSurface,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//         elevation: 8,
//       ),

//       // Divider Theme
//       dividerTheme: const DividerThemeData(
//         color: AppColors.darkDivider,
//         thickness: 1,
//       ),

//       // Icon Theme
//       iconTheme: const IconThemeData(color: AppColors.darkTextPrimary),

//       // Text Theme
//       textTheme: const TextTheme(
//         displayLarge: TextStyle(
//           fontFamily: 'Inter',
//           color: AppColors.darkTextPrimary,
//           fontWeight: FontWeight.bold,
//         ),
//         displayMedium: TextStyle(
//           fontFamily: 'Inter',
//           color: AppColors.darkTextPrimary,
//           fontWeight: FontWeight.bold,
//         ),
//         displaySmall: TextStyle(
//           fontFamily: 'Inter',
//           color: AppColors.darkTextPrimary,
//           fontWeight: FontWeight.bold,
//         ),
//         headlineLarge: TextStyle(
//           fontFamily: 'Inter',
//           color: AppColors.darkTextPrimary,
//           fontWeight: FontWeight.w600,
//         ),
//         headlineMedium: TextStyle(
//           fontFamily: 'Inter',
//           color: AppColors.darkTextPrimary,
//           fontWeight: FontWeight.w600,
//         ),
//         headlineSmall: TextStyle(
//           fontFamily: 'Inter',
//           color: AppColors.darkTextPrimary,
//           fontWeight: FontWeight.w600,
//         ),
//         titleLarge: TextStyle(
//           fontFamily: 'Inter',
//           color: AppColors.darkTextPrimary,
//           fontWeight: FontWeight.w600,
//         ),
//         titleMedium: TextStyle(
//           fontFamily: 'Inter',
//           color: AppColors.darkTextPrimary,
//           fontWeight: FontWeight.w500,
//         ),
//         titleSmall: TextStyle(
//           fontFamily: 'Inter',
//           color: AppColors.darkTextPrimary,
//           fontWeight: FontWeight.w500,
//         ),
//         bodyLarge: TextStyle(
//           fontFamily: 'Inter',
//           color: AppColors.darkTextPrimary,
//         ),
//         bodyMedium: TextStyle(
//           fontFamily: 'Inter',
//           color: AppColors.darkTextPrimary,
//         ),
//         bodySmall: TextStyle(
//           fontFamily: 'Inter',
//           color: AppColors.darkTextSecondary,
//         ),
//         labelLarge: TextStyle(
//           fontFamily: 'Inter',
//           color: AppColors.darkTextPrimary,
//           fontWeight: FontWeight.w600,
//         ),
//         labelMedium: TextStyle(
//           fontFamily: 'Inter',
//           color: AppColors.darkTextSecondary,
//         ),
//         labelSmall: TextStyle(
//           fontFamily: 'Inter',
//           color: AppColors.darkTextTertiary,
//         ),
//       ),

//       // Chip Theme
//       chipTheme: ChipThemeData(
//         backgroundColor: AppColors.darkSurfaceVariant,
//         labelStyle: const TextStyle(
//           fontFamily: 'Inter',
//           color: AppColors.darkTextPrimary,
//           fontSize: 13,
//           fontWeight: FontWeight.w500,
//         ),
//         side: BorderSide.none,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//       ),

//       // Floating Action Button Theme
//       floatingActionButtonTheme: const FloatingActionButtonThemeData(
//         backgroundColor: AppColors.primary,
//         foregroundColor: Colors.white,
//         elevation: 4,
//       ),

//       // Switch Theme
//       switchTheme: SwitchThemeData(
//         thumbColor: WidgetStateProperty.resolveWith((states) {
//           if (states.contains(WidgetState.selected)) {
//             return Colors.white;
//           }
//           return AppColors.darkTextTertiary;
//         }),
//         trackColor: WidgetStateProperty.resolveWith((states) {
//           if (states.contains(WidgetState.selected)) {
//             return AppColors.primary;
//           }
//           return AppColors.darkBorder;
//         }),
//       ),

//       // Snackbar Theme
//       snackBarTheme: SnackBarThemeData(
//         backgroundColor: AppColors.darkSurfaceVariant,
//         contentTextStyle: const TextStyle(
//           fontFamily: 'Inter',
//           color: AppColors.darkTextPrimary,
//           fontSize: 14,
//         ),
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         behavior: SnackBarBehavior.floating,
//       ),

//       // Progress Indicator Theme
//       progressIndicatorTheme: const ProgressIndicatorThemeData(
//         color: AppColors.primary,
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTheme {
  // Light Theme (based on your original theme)
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: false, // Keep Material 2 for consistency with your original
      fontFamily: 'Jost Regular',
      scaffoldBackgroundColor: Colors.grey[200],

      // Text Theme
      textTheme: const TextTheme(
        bodyLarge: TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),

      // AppBar Theme
      appBarTheme: AppBarTheme(
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        titleTextStyle: const TextStyle(
          fontFamily: 'Jost SemiBold',
          color: Colors.black,
          fontSize: 22,
          letterSpacing: 0.5,
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(0)),
        filled: true,
        fillColor: Colors.white,
      ),

      // Bottom Navigation Theme
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedIconTheme: IconThemeData(size: 28),
        unselectedIconTheme: IconThemeData(size: 28),
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
      ),

      // Card Theme
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }

  // Dark Theme (new - based on your original but with dark colors)
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: false,
      fontFamily: 'Jost Regular',
      scaffoldBackgroundColor: const Color(0xFF121212), // Dark background
      brightness: Brightness.dark,

      // Text Theme
      textTheme: const TextTheme(
        bodyLarge: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),

      // AppBar Theme
      appBarTheme: const AppBarTheme(
        foregroundColor: Colors.white,
        backgroundColor: Color(0xFF1E1E1E), // Dark surface
        centerTitle: true,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        titleTextStyle: TextStyle(
          fontFamily: 'Jost SemiBold',
          color: Colors.white,
          fontSize: 22,
          letterSpacing: 0.5,
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(0),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        filled: true,
        fillColor: const Color(0xFF2C2C2C), // Dark input background
        labelStyle: const TextStyle(color: Colors.grey),
        hintStyle: const TextStyle(color: Colors.grey),
      ),

      // Bottom Navigation Theme
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color(0xFF1E1E1E),
        selectedIconTheme: IconThemeData(size: 28),
        unselectedIconTheme: IconThemeData(size: 28),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
      ),

      // Card Theme
      cardTheme: CardThemeData(
        color: const Color(0xFF1E1E1E), // Dark card
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 2,
          backgroundColor: const Color(0xFF2C2C2C),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),

      // Icon Theme
      iconTheme: const IconThemeData(color: Colors.white),

      // Divider Theme
      dividerTheme: const DividerThemeData(color: Colors.grey, thickness: 1),
    );
  }
}
