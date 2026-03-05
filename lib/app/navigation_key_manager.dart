// core/utils/services/navigation_key_holder.dart
import 'package:flutter/material.dart';

class NavigationKeyManager {
  late final GlobalKey<NavigatorState> navigatorKey;

  NavigationKeyManager() {
    navigatorKey = GlobalKey<NavigatorState>();
  }
}
