import 'package:flutter/material.dart';

abstract class ThemeConstants {
  static const cardRadius = 24.0;
  static const fieldRadius = 8.0;

  static const defaultPadding = 16.0;

  /// The radius for custom container clippers.
  static const double customContainerClipperRadius = 75.0;

  /// --------------------------------------------------------------------------
  /// THEME COLORS
  /// --------------------------------------------------------------------------

  static const lightBgColor = Color.fromARGB(255, 243, 243, 243);
  static const darkBgColor = Color(0xFF1a1a1a);
  static const lightCardBgColor = Colors.white;
  static const darkCardBgColor = Color.fromARGB(255, 46, 46, 46);
  static const hintColor = Colors.black12;
  static const darkHintColor = Colors.white30;

  ThemeConstants._();
}
