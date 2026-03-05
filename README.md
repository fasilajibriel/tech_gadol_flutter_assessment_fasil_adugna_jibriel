# Tech Gadol Flutter Assessment

This repository is a Flutter assessment project structured with core/shared modules, feature modules, dependency injection, and app-level routing.

## Architecture Overview

Current layout:

- `lib/app`: app shell, route definitions, navigation key management, router config.
- `lib/core`: shared technical foundations (config, constants, domain contracts, implementations, errors, helpers, network services).
- `lib/features`: feature-specific UI/state (`splash`, `home`).
- `lib/di`: `get_it` registration and lifecycle setup.
- `lib/shared`: reusable theme/models.

Design direction:

- Core-first layered design (`core/domain` contracts, `core/data` implementations).
- Provider-based state management for app-level state (`ThemeProvider`, `SplashProvider`).
- GoRouter-based declarative navigation.

## Flavor Setup and Run Commands

Flavor patterns and setup rules are documented in `flavor_setup.md`.

- I defined flavor setup rules and used AI to generate repetitive base setup content, then adjusted it for this codebase.
- The generated output accelerated setup but still needs manual verification for environment parity and edge cases.

Run examples:

```bash
flutter run --dart-define=FLAVOR=dev
flutter run --dart-define=FLAVOR=uat
flutter run --dart-define=FLAVOR=prod
```

When platform flavor configs are wired (Android/iOS/macOS), you can pair with `--flavor`:

```bash
flutter run --flavor dev --dart-define=FLAVOR=dev
```

## DI and Navigation Approach

### Dependency Injection

- Implemented with `get_it` in `lib/di/injector.dart`.
- Registers app services (`AppLogger`, `LocalStorageManager`, `ApiService`, `AppRouter`) and providers.
- `setupDependencies()` runs before `runApp`.

### Navigation

- Route definitions live in `lib/app/routes.dart`.
- Router config lives in `lib/app/go_router_config.dart`.
- Navigation abstraction (`AppRouter`) is implemented by `AppRouterImpl` to avoid calling router APIs directly from providers/business flow.

## Design System Rationale

- Component API choices currently prioritize fast delivery and readability over deep customization.
- Theming is centralized through `ThemeConstants` and `AppTheme` to keep light/dark behavior and color usage consistent across screens.
- The current implementation applies brand colors first; full brand expression (logo integration, broader component styling, and richer visual tokens) is only partially implemented.

## Limitations and Shortcuts

### Improvements With More Time

- Design and implement a dedicated showcase page.
- Improve loading states with shimmer-based skeletons instead of basic loaders.
- Add company logo usage on splash and across the wider theme system (beyond colors).
- Separate presentation content into smaller widgets and group them by feature.
- Presentation content is still too page-heavy in places and I would split into smaller reusable widgets for better composition and maintainability.

### Shortcuts Taken

- Incorporated icon packages to move faster on icon coverage.
- Referred to Pinterest for UI idea exploration and visual direction.

## AI Usage and Engineering Critique

AI-assisted work in this project:

- Used AI for repetitive implementation tasks (boilerplate generation, explicit state handling after the first pattern was designed).
- Used AI to speed up flavor-setup scaffolding.
- Used AI to make the README more professional after providing clear guidance.
- Used AI to help write tests, then refined outputs manually.
- Used AI to critique and improve the codebase.

## Quality Gates

- Linting and static checks: `flutter analyze`
- Tests: `flutter test`
