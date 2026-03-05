import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/app/navigation_key_manager.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/app/routes.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/di/injector.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/features/product/presentation/state/product_provider.dart';
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
    GoRoute(
      path: Routes.product.path,
      builder: (context, state) {
        final productId = int.tryParse(state.pathParameters['id'] ?? '');
        if (productId == null) {
          return const Scaffold(
            body: Center(child: Text('Invalid product id')),
          );
        }

        return ChangeNotifierProvider(
          create: (_) => getIt<ProductProvider>()..loadProduct(productId),
          child: Routes.product.builder(context, productId),
        );
      },
    ),
  ],
  redirect: (context, state) async {
    return null;
  },
);

class GoRouterConfig {
  static GoRouter getRouter() => _appRouter;
}
