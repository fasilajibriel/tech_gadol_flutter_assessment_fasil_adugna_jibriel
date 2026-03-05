import 'package:flutter/widgets.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/features/home/presentation/pages/home_page.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/features/product/presentation/pages/product_page.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/features/splash/presentation/pages/splash_page.dart';

abstract class AppRoute {
  final String name;
  final String path;

  const AppRoute({required this.name, required this.path});

  Widget builder(BuildContext context, Object? args);
}

class SplashRoute extends AppRoute {
  const SplashRoute() : super(name: 'splash', path: '/splash');

  @override
  Widget builder(BuildContext context, Object? args) => const SplashPage();
}

class HomeRoute extends AppRoute {
  const HomeRoute() : super(name: 'home', path: '/home');

  @override
  Widget builder(BuildContext context, Object? args) => const HomePage();
}

class ProductRoute extends AppRoute {
  const ProductRoute() : super(name: 'product', path: '/products/:id');

  String pathFromId(int id) => '/products/$id';

  @override
  Widget builder(BuildContext context, Object? args) {
    final productId = args is int ? args : 0;
    return ProductPage(productId: productId);
  }
}

class Routes {
  static const splash = SplashRoute();
  static const home = HomeRoute();
  static const product = ProductRoute();
}
