import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/app/navigation_key_manager.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/app/routes.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/di/injector.dart';
import 'package:go_router/go_router.dart';

final GoRouter _appRouter = GoRouter(
  navigatorKey: getIt<NavigationKeyManager>().navigatorKey,
  initialLocation: Routes.splash.path,
  routes: [
    GoRoute(
      path: Routes.splash.path,
      builder: (context, state) => Routes.splash.builder(context, state.extra),
    ),
    GoRoute(
      path: Routes.home.path,
      builder: (context, state) => Routes.home.builder(context, state.extra),
    ),
  ],
  redirect: (context, state) async {
    return null;
  },
);

class GoRouterConfig {
  static GoRouter getRouter() => _appRouter;
}
