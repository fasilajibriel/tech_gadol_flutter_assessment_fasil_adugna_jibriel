import 'package:flutter/material.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/core/constants/storage_constants.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/core/domain/local_storage_manager.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/shared/theme/app_theme.dart';

class ThemeProvider extends ChangeNotifier {
  final LocalStorageManager _localStorageManager;
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  ThemeData get currentTheme {
    switch (_themeMode) {
      case ThemeMode.light:
        return AppTheme.lightTheme;
      case ThemeMode.dark:
        return AppTheme.darkTheme;
      case ThemeMode.system:
        // For system mode, we need to determine the current system brightness
        // This will be handled in the App widget using MediaQuery
        return AppTheme.lightTheme; // Default fallback
    }
  }

  ThemeProvider(this._localStorageManager);

  /// Initialize the theme from storage or system settings
  Future<void> initialize() async {
    // Try to load saved theme from storage
    final result = await _localStorageManager.readString(StorageConstants.themeModeKey);

    result.fold(
      (failure) {
        // If reading from storage fails, use system theme
        _themeMode = ThemeMode.system;
      },
      (savedTheme) {
        if (savedTheme.isNotEmpty) {
          // Parse saved theme mode
          switch (savedTheme) {
            case 'light':
              _themeMode = ThemeMode.light;
              break;
            case 'dark':
              _themeMode = ThemeMode.dark;
              break;
            case 'system':
            default:
              _themeMode = ThemeMode.system;
              break;
          }
        } else {
          // If no theme is saved, use system theme
          _themeMode = ThemeMode.system;
        }
      },
    );

    notifyListeners();
  }

  /// Sets the theme mode and saves it to storage
  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    notifyListeners();

    // Save theme mode to storage
    final themeString = _themeModeToString(mode);
    await _localStorageManager.writeString(StorageConstants.themeModeKey, themeString);
  }

  /// Toggles between light and dark modes
  Future<void> toggleTheme() async {
    final newMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    await setThemeMode(newMode);
  }

  /// Converts ThemeMode to string for storage
  String _themeModeToString(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.system:
        return 'system';
    }
  }

  /// Determines the effective theme mode based on current settings and system brightness
  ThemeMode getEffectiveThemeMode(Brightness systemBrightness) {
    if (_themeMode == ThemeMode.system) {
      return systemBrightness == Brightness.dark ? ThemeMode.dark : ThemeMode.light;
    }
    return _themeMode;
  }

  /// Gets the effective theme data based on current settings and system brightness
  ThemeData getEffectiveTheme(Brightness systemBrightness) {
    final effectiveMode = getEffectiveThemeMode(systemBrightness);
    return AppTheme.getTheme(effectiveMode);
  }
}
