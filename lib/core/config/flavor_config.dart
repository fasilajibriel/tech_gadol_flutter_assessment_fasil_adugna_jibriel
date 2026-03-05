import 'package:flutter/material.dart';

enum Flavor { mock, dev, uat, prod }

enum AppEnvironment { mock, development, staging, production }

class FlavorConfig {
  final Flavor flavor;
  final String environment;
  final String appName;
  final String baseUrlKey;
  final Color primaryColor;
  final Color secondaryColor;
  final bool isProduction;

  const FlavorConfig._({
    required this.flavor,
    required this.environment,
    required this.appName,
    required this.baseUrlKey,
    required this.primaryColor,
    required this.secondaryColor,
    required this.isProduction,
  });

  static FlavorConfig? _instance;

  static void initialize(Flavor flavor) {
    switch (flavor) {
      case Flavor.mock:
        _instance = const FlavorConfig._(
          flavor: Flavor.mock,
          environment: 'mock',
          appName: 'Tech Gadol Assessment (Mock)',
          baseUrlKey: 'MOCK_BASE_URL',
          primaryColor: Color(0xFF1f589c),
          secondaryColor: Color(0xFF21ac4b),
          isProduction: false,
        );
        break;
      case Flavor.dev:
        _instance = const FlavorConfig._(
          flavor: Flavor.dev,
          environment: 'development',
          appName: 'Tech Gadol Assessment (Dev)',
          baseUrlKey: 'DEV_BASE_URL',
          primaryColor: Color(0xFF1f589c),
          secondaryColor: Color(0xFF21ac4b),
          isProduction: false,
        );
        break;
      case Flavor.uat:
        _instance = const FlavorConfig._(
          flavor: Flavor.uat,
          environment: 'staging',
          appName: 'Tech Gadol Assessment (UAT)',
          baseUrlKey: 'UAT_BASE_URL',
          primaryColor: Color(0xFF1f589c),
          secondaryColor: Color(0xFF21ac4b),
          isProduction: false,
        );
        break;
      case Flavor.prod:
        _instance = const FlavorConfig._(
          flavor: Flavor.prod,
          environment: 'production',
          appName: 'Tech Gadol Assessment',
          baseUrlKey: 'BASE_URL',
          primaryColor: Color(0xFF1f589c),
          secondaryColor: Color(0xFF21ac4b),
          isProduction: true,
        );
        break;
    }
  }

  static Flavor fromName(String value) {
    return Flavor.values.firstWhere(
      (flavor) => flavor.name == value.toLowerCase(),
      orElse: () => Flavor.dev,
    );
  }

  static FlavorConfig get instance {
    final config = _instance;
    if (config == null) {
      throw StateError('FlavorConfig has not been initialized.');
    }
    return config;
  }

  bool get isMock => flavor == Flavor.mock;
}
