import 'package:flutter/material.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/core/config/flavor_config.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/core/constants/theme_constants.dart';

class AppTheme {
  // Private constructor
  AppTheme._();

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: FlavorConfig.instance.primaryColor,
      scaffoldBackgroundColor: ThemeConstants.lightBgColor,

      // 1. Color Scheme (The modern way to handle colors)
      colorScheme: ColorScheme.fromSeed(
        brightness: Brightness.light,
        seedColor: FlavorConfig.instance.primaryColor,
        primary: FlavorConfig.instance.primaryColor,
        secondary: FlavorConfig.instance.secondaryColor,
        surface: ThemeConstants.lightBgColor,
      ),

      // 2. Typography
      textTheme: const TextTheme(
        displayLarge: TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
        bodyLarge: TextStyle(fontWeight: FontWeight.normal, fontSize: 16),
      ),

      // 3. Button Themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: FlavorConfig.instance.primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(ThemeConstants.fieldRadius)),
          padding: const EdgeInsets.all(ThemeConstants.defaultPadding),
        ),
      ),

      // 4. Input Decoration (Text fields)
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ThemeConstants.fieldRadius),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.all(ThemeConstants.defaultPadding),
      ),

      // 5. Card Theme
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(ThemeConstants.cardRadius)),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: FlavorConfig.instance.primaryColor,
      scaffoldBackgroundColor: ThemeConstants.darkBgColor,

      // 1. Color Scheme (The modern way to handle colors)
      colorScheme: ColorScheme.fromSeed(
        brightness: Brightness.dark,
        seedColor: FlavorConfig.instance.primaryColor,
        primary: FlavorConfig.instance.primaryColor,
        secondary: FlavorConfig.instance.secondaryColor,
        surface: ThemeConstants.darkBgColor,
      ),

      // 2. Typography
      textTheme: const TextTheme(
        displayLarge: TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
        bodyLarge: TextStyle(fontWeight: FontWeight.normal, fontSize: 16),
      ),

      // 3. Button Themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: FlavorConfig.instance.primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(ThemeConstants.fieldRadius)),
          padding: const EdgeInsets.all(ThemeConstants.defaultPadding),
        ),
      ),

      // 4. Input Decoration (Text fields)
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.grey[800],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ThemeConstants.fieldRadius),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.all(ThemeConstants.defaultPadding),
      ),

      // 5. Card Theme
      cardTheme: CardThemeData(
        color: Colors.grey[800],
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(ThemeConstants.cardRadius)),
      ),
    );
  }

  /// Returns the appropriate theme data based on the given [ThemeMode]
  static ThemeData getTheme(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return lightTheme;
      case ThemeMode.dark:
        return darkTheme;
      case ThemeMode.system:
        // Default to light if system theme is not determinable
        return lightTheme;
    }
  }
}
