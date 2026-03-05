import 'package:flutter_test/flutter_test.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/core/domain/app_logger.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/features/home/data/models/products_response_model/product.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/shared/helpers/product_data_guard.dart';

class _FakeLogger implements AppLogger {
  final List<String> warnings = <String>[];
  final List<String> errors = <String>[];

  @override
  void debug(String message, {String? className, String? methodName}) {}

  @override
  void info(String message, {String? className, String? methodName}) {}

  @override
  void warning(String message, {String? className, String? methodName}) {
    warnings.add(message);
  }

  @override
  void error(
    String message, {
    String? className,
    String? methodName,
    Object? error,
    StackTrace? stackTrace,
  }) {
    errors.add(message);
  }
}

void main() {
  group('Product.fromMap', () {
    test('casts mixed list values into List<String> without throwing', () {
      final model = Product.fromMap({
        'id': '10',
        'title': ' Phone ',
        'price': '99.5',
        'tags': ['android', 123, null, ' '],
        'images': ['https://example.com/1.png', 777, null, ''],
      });

      expect(model.id, 10);
      expect(model.title, 'Phone');
      expect(model.price, 99.5);
      expect(model.tags, <String>['android', '123']);
      expect(model.images, <String>['https://example.com/1.png', '777']);
    });

    test('returns null for non-list tags and images', () {
      final model = Product.fromMap({
        'tags': 'not-a-list',
        'images': {'url': 'https://example.com'},
      });

      expect(model.tags, isNull);
      expect(model.images, isNull);
    });
  });

  group('ProductDataGuard', () {
    test('uses thumbnail as primary image when images are invalid', () {
      const product = Product(
        images: <String>['', 'invalid-url'],
        thumbnail: 'https://example.com/thumb.png',
      );

      expect(
        ProductDataGuard.primaryImageUrl(product),
        'https://example.com/thumb.png',
      );
    });

    test('returns unavailable label for missing or negative price', () {
      const missingPrice = Product(id: 201);
      const negativePrice = Product(id: 202, price: -5);

      expect(ProductDataGuard.priceLabel(missingPrice), 'Price unavailable');
      expect(ProductDataGuard.priceLabel(negativePrice), 'Price unavailable');
    });

    test('provides safe text defaults for missing fields', () {
      const product = Product();

      expect(ProductDataGuard.displayTitle(product), 'Unnamed product');
      expect(ProductDataGuard.displayBrand(product), 'Unknown brand');
      expect(
        ProductDataGuard.displayDescription(product),
        'No description available.',
      );
      expect(ProductDataGuard.displayCategory(product), 'Uncategorized');
    });

    test('logs image and price issues through logger', () {
      final logger = _FakeLogger();
      const product = Product(id: 300, title: 'Broken item', price: -1);

      ProductDataGuard.logImageWarningIfNeeded(
        product,
        logger,
        source: 'ProductCardTest',
      );
      ProductDataGuard.logPriceErrorIfNeeded(
        product,
        logger,
        source: 'ProductCardTest',
      );

      expect(logger.warnings.length, 1);
      expect(logger.errors.length, 1);
      expect(logger.warnings.first, contains('Missing or invalid image URL'));
      expect(logger.errors.first, contains('Missing or negative price'));
    });
  });
}
