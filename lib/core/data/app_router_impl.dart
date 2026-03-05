import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/app/navigation_key_manager.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/core/domain/app_router.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/core/error/failure.dart';
import 'package:go_router/go_router.dart';

class AppRouterImpl implements AppRouter {
  final NavigationKeyManager _keyManager;

  AppRouterImpl(this._keyManager);

  @override
  void push<T>(String routePath, {T? args}) {
    _assertKeyReady();
    try {
      GoRouter.of(_keyManager.navigatorKey.currentContext!).push(routePath, extra: args);
    } on Exception catch (e) {
      throw NavigationFailure(message: 'Push navigation failed: ${e.toString()}');
    }
  }

  @override
  void go<T>(String routePath, {T? args}) {
    _assertKeyReady();
    try {
      GoRouter.of(_keyManager.navigatorKey.currentContext!).go(routePath, extra: args);
    } on Exception catch (e) {
      throw NavigationFailure(message: 'Go navigation failed: ${e.toString()}');
    }
  }

  @override
  void pop() {
    _assertKeyReady();
    try {
      GoRouter.of(_keyManager.navigatorKey.currentContext!).pop();
    } on Exception catch (e) {
      throw NavigationFailure(message: 'Pop navigation failed: ${e.toString()}');
    }
  }

  void _assertKeyReady() {
    if (_keyManager.navigatorKey.currentContext == null) {
      throw const NavigationFailure(
        message: 'Navigation key not initialized. Ensure RouterKeyManager is properly set up.',
      );
    }
  }
}
