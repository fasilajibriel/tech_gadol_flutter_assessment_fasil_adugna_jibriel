class APIConstants {
  // API endpoints
  static const String products = '/products';
  static const String productCategories = '/products/categories';
  static const String productSearch = '/products/search';

  static String productsByCategory(String category) =>
      '/products/category/${Uri.encodeComponent(category)}';

  static String productById(int id) => '/products/$id';
}
