# Flutter Flavor Setup Guide (`mock`, `dev`, `uat`, `prod`)

This is a generic flavor setup guide for Flutter apps.

## Required Inputs (Ask First)

Before implementation, ask the user for:

- `{NAMESPACE}`: reverse-domain root package (example: `com.example.project`)
- `{APP_NAME}`: user-facing app name (example: `Example App`)
- `{PROJECT_SLUG}`: filesystem/build slug (example: `example-app`)
- `{BUNDLE_BASE}`: base application identifier (example: `{NAMESPACE}.app` or `{NAMESPACE}.{PROJECT_KEY}`)
- Flavor package strategy:
  - Option A: prod is base id (`{BUNDLE_BASE}`), others append `.mock/.dev/.uat`
  - Option B: all append suffix including prod (`{BUNDLE_BASE}.prod`, `.mock`, `.dev`, `.uat`)

Use these values consistently across Android/iOS/macOS/Windows.

## Overview

Flavor system:

- `--flavor` (Android/iOS/macOS build flavor)
- `--dart-define=FLAVOR=<mock|dev|uat|prod>` (runtime flavor)
- `.env.config_file` for environment base URLs
- Android `productFlavors`
- iOS schemes + build configurations
- macOS schemes
- Windows runtime flavor selection via `--dart-define`
- `FlavorConfig` as single runtime source of truth

## Supported Flavors

- `mock`: offline/local mocked responses
- `dev`: development backend
- `uat`: UAT/staging backend
- `prod`: production backend

## 1. Project Configuration

### 1.1 Environment file

Create/update `.env.config_file`:

```env
MOCK_BASE_URL=http://local_storage
DEV_BASE_URL=https://dev-api.example.com/api/v1
UAT_BASE_URL=https://uat-api.example.com/api/v1
PROD_BASE_URL=https://api.example.com/api/v1
```

### 1.2 `pubspec.yaml`

```yaml
dependencies:
  flutter_dotenv: ^6.0.0

flutter:
  assets:
    - .env.config_file
```

## 2. Flutter Runtime Flavor Config

### 2.1 `FlavorConfig`

File: `lib/core/config/flavor_config.dart`

```dart
import 'package:flutter/material.dart';

enum Flavor { mock, dev, uat, prod }

class FlavorConfig {
  final Flavor flavor;
  final String appName;
  final String baseUrlKey;
  final bool isProduction;

  const FlavorConfig._({
    required this.flavor,
    required this.appName,
    required this.baseUrlKey,
    required this.isProduction,
  });

  static FlavorConfig? _instance;

  static void initialize(Flavor flavor) {
    switch (flavor) {
      case Flavor.mock:
        _instance = const FlavorConfig._(
          flavor: Flavor.mock,
          appName: '{APP_NAME} (Mock)',
          baseUrlKey: 'MOCK_BASE_URL',
          isProduction: false,
        );
        break;
      case Flavor.dev:
        _instance = const FlavorConfig._(
          flavor: Flavor.dev,
          appName: '{APP_NAME} (Dev)',
          baseUrlKey: 'DEV_BASE_URL',
          isProduction: false,
        );
        break;
      case Flavor.uat:
        _instance = const FlavorConfig._(
          flavor: Flavor.uat,
          appName: '{APP_NAME} (UAT)',
          baseUrlKey: 'UAT_BASE_URL',
          isProduction: false,
        );
        break;
      case Flavor.prod:
        _instance = const FlavorConfig._(
          flavor: Flavor.prod,
          appName: '{APP_NAME}',
          baseUrlKey: 'PROD_BASE_URL',
          isProduction: true,
        );
        break;
    }
  }

  static Flavor fromName(String value) =>
      Flavor.values.firstWhere((f) => f.name == value.toLowerCase(), orElse: () => Flavor.dev);

  static FlavorConfig get instance {
    final value = _instance;
    if (value == null) throw StateError('FlavorConfig is not initialized');
    return value;
  }
}
```

### 2.2 Initialize in `main.dart`

```dart
const flavorName = String.fromEnvironment('FLAVOR', defaultValue: 'dev');
FlavorConfig.initialize(FlavorConfig.fromName(flavorName));
```

### 2.3 Use in app shell

- `title: FlavorConfig.instance.appName`
- `debugShowCheckedModeBanner: !FlavorConfig.instance.isProduction`

## 3. Android Flavors

### 3.1 `android/app/build.gradle.kts`

```kotlin
android {
    namespace = "{BUNDLE_BASE}" // e.g. com.example.project.app
    flavorDimensions += "environment"

    defaultConfig {
        // Option A or B (based on agreed strategy)
        applicationId = "{BUNDLE_BASE}" // or {BUNDLE_BASE}.prod
    }

    productFlavors {
        create("mock") {
            dimension = "environment"
            applicationId = "{BUNDLE_BASE}.mock"
            resValue("string", "app_name", "{APP_NAME} (Mock)")
            manifestPlaceholders["mainActivityClass"] = "{BUNDLE_BASE}.mock.MainActivity"
        }
        create("dev") {
            dimension = "environment"
            applicationId = "{BUNDLE_BASE}.dev"
            resValue("string", "app_name", "{APP_NAME} (Dev)")
            manifestPlaceholders["mainActivityClass"] = "{BUNDLE_BASE}.dev.MainActivity"
        }
        create("uat") {
            dimension = "environment"
            applicationId = "{BUNDLE_BASE}.uat"
            resValue("string", "app_name", "{APP_NAME} (UAT)")
            manifestPlaceholders["mainActivityClass"] = "{BUNDLE_BASE}.uat.MainActivity"
        }
        create("prod") {
            dimension = "environment"
            applicationId = "{BUNDLE_BASE}" // or {BUNDLE_BASE}.prod
            resValue("string", "app_name", "{APP_NAME}")
            manifestPlaceholders["mainActivityClass"] = "{BUNDLE_BASE}.prod.MainActivity" // or {BUNDLE_BASE}.MainActivity
        }
    }

    sourceSets {
        getByName("main").java.srcDirs("src/main/kotlin")
        getByName("mock").manifest.srcFile("src/main/AndroidManifest.xml")
        getByName("dev").manifest.srcFile("src/main/AndroidManifest.xml")
        getByName("uat").manifest.srcFile("src/main/AndroidManifest.xml")
        getByName("prod").manifest.srcFile("src/main/AndroidManifest.xml")
    }
}
```

### 3.2 MainActivity per flavor

Create:

- `android/app/src/main/kotlin/{NAMESPACE_PATH}/mock/MainActivity.kt`
- `android/app/src/main/kotlin/{NAMESPACE_PATH}/dev/MainActivity.kt`
- `android/app/src/main/kotlin/{NAMESPACE_PATH}/uat/MainActivity.kt`
- `android/app/src/main/kotlin/{NAMESPACE_PATH}/prod/MainActivity.kt`

Where `{NAMESPACE_PATH}` is `{BUNDLE_BASE}` with dots replaced by slashes.

Each file:

```kotlin
package {BUNDLE_BASE}.mock // dev/uat/prod accordingly

import io.flutter.embedding.android.FlutterActivity

class MainActivity : FlutterActivity()
```

### 3.3 Manifest

File: `android/app/src/main/AndroidManifest.xml`

```xml
<application
    android:label="@string/app_name"
    android:name="${applicationName}"
    android:icon="@mipmap/ic_launcher">
    <activity android:name="${mainActivityClass}" ... />
</application>
```

## 4. iOS Flavors

### 4.1 Schemes

Create shared schemes under `ios/Runner.xcodeproj/xcshareddata/xcschemes/`:

- `mock`
- `dev`
- `uat`
- `prod`

### 4.2 Build configurations

Add:

- `Debug-mock`, `Release-mock`, `Profile-mock`
- `Debug-dev`, `Release-dev`, `Profile-dev`
- `Debug-uat`, `Release-uat`, `Profile-uat`
- `Debug-prod`, `Release-prod`, `Profile-prod`

Map them in `ios/Podfile`.

### 4.3 Bundle IDs and names

For each iOS flavor config in `Runner` target set:

- `PRODUCT_BUNDLE_IDENTIFIER`:
  - `mock`: `{BUNDLE_BASE}.mock`
  - `dev`: `{BUNDLE_BASE}.dev`
  - `uat`: `{BUNDLE_BASE}.uat`
  - `prod`: `{BUNDLE_BASE}` or `{BUNDLE_BASE}.prod` (match chosen strategy)
- `PRODUCT_NAME`:
  - `{APP_NAME} (Mock|Dev|UAT)` and `{APP_NAME}` for prod

`Info.plist` should use:

```xml
<key>CFBundleDisplayName</key>
<string>$(PRODUCT_NAME)</string>
<key>CFBundleIdentifier</key>
<string>$(PRODUCT_BUNDLE_IDENTIFIER)</string>
```

## 5. macOS Flavors

- Create macOS shared schemes: `mock`, `dev`, `uat`, `prod`.
- Use `--flavor <name>` with `--dart-define=FLAVOR=<name>`.
- Keep app config generic in `macos/Runner/Configs/AppInfo.xcconfig`:
  - `PRODUCT_NAME = {PROJECT_SLUG}`
  - `PRODUCT_BUNDLE_IDENTIFIER = {BUNDLE_BASE}`

## 6. Windows Flavors

Windows uses runtime flavoring only:

- Use `--dart-define=FLAVOR=<mock|dev|uat|prod>`
- Optionally align app metadata with placeholders:
  - `windows/CMakeLists.txt` (`project(...)`, `BINARY_NAME`)
  - `windows/runner/main.cpp` (window title)
  - `windows/runner/Runner.rc` metadata fields

## 7. IDE Run Configurations

### 7.1 VS Code

Create launch entries for all flavors:

- Android/iOS/macOS: include `--flavor` + `--dart-define`
- Windows: include `--dart-define`

### 7.2 Android Studio / IntelliJ

Create corresponding run configs per flavor.

## 8. Commands (Verbose)

### 8.1 Run

```bash
flutter run --verbose --flavor mock --dart-define=FLAVOR=mock
flutter run --verbose --flavor dev --dart-define=FLAVOR=dev
flutter run --verbose --flavor uat --dart-define=FLAVOR=uat
flutter run --verbose --flavor prod --dart-define=FLAVOR=prod

flutter run --verbose -d macos --flavor mock --dart-define=FLAVOR=mock
flutter run --verbose -d macos --flavor dev --dart-define=FLAVOR=dev
flutter run --verbose -d macos --flavor uat --dart-define=FLAVOR=uat
flutter run --verbose -d macos --flavor prod --dart-define=FLAVOR=prod

flutter run --verbose -d windows --dart-define=FLAVOR=mock
flutter run --verbose -d windows --dart-define=FLAVOR=dev
flutter run --verbose -d windows --dart-define=FLAVOR=uat
flutter run --verbose -d windows --dart-define=FLAVOR=prod
```

### 8.2 Build

```bash
flutter build apk --verbose --release --flavor mock --dart-define=FLAVOR=mock
flutter build apk --verbose --release --flavor dev --dart-define=FLAVOR=dev
flutter build apk --verbose --release --flavor uat --dart-define=FLAVOR=uat
flutter build apk --verbose --release --flavor prod --dart-define=FLAVOR=prod

flutter build appbundle --verbose --release --flavor mock --dart-define=FLAVOR=mock
flutter build appbundle --verbose --release --flavor dev --dart-define=FLAVOR=dev
flutter build appbundle --verbose --release --flavor uat --dart-define=FLAVOR=uat
flutter build appbundle --verbose --release --flavor prod --dart-define=FLAVOR=prod

flutter build ios --verbose --release --flavor mock --dart-define=FLAVOR=mock
flutter build ios --verbose --release --flavor dev --dart-define=FLAVOR=dev
flutter build ios --verbose --release --flavor uat --dart-define=FLAVOR=uat
flutter build ios --verbose --release --flavor prod --dart-define=FLAVOR=prod

flutter build macos --verbose --release --flavor mock --dart-define=FLAVOR=mock
flutter build macos --verbose --release --flavor dev --dart-define=FLAVOR=dev
flutter build macos --verbose --release --flavor uat --dart-define=FLAVOR=uat
flutter build macos --verbose --release --flavor prod --dart-define=FLAVOR=prod

flutter build windows --verbose --release --dart-define=FLAVOR=mock
flutter build windows --verbose --release --dart-define=FLAVOR=dev
flutter build windows --verbose --release --dart-define=FLAVOR=uat
flutter build windows --verbose --release --dart-define=FLAVOR=prod
```

## 9. Validation Checklist

- Asked and captured `{NAMESPACE}`, `{APP_NAME}`, `{PROJECT_SLUG}`, `{BUNDLE_BASE}` first.
- Android namespace and flavor IDs follow chosen strategy.
- Android manifest uses `mainActivityClass` placeholder.
- iOS schemes + build configs exist for all four flavors.
- iOS bundle IDs match chosen strategy.
- macOS schemes exist and run with `--flavor`.
- Windows runs with `--dart-define` for all flavors.
- All command examples use `--verbose`.

## 10. Common Pitfalls

- Using hardcoded project-specific package names in a reusable guide.
- Mixing prod ID strategies mid-project (base vs `.prod`).
- Passing `--flavor` on Windows builds.
- Missing one flavor in schemes/build configs.
- Forgetting to align app/package identifiers in all platform files.
