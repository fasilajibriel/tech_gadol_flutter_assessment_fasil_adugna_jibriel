import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/core/domain/app_logger.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/features/home/data/models/products_response_model/product.dart';

class ProductDataGuard {
  static final Set<String> _warnedImageKeys = <String>{};
  static final Set<String> _warnedImageLoadFailureKeys = <String>{};
  static final Set<String> _erroredPriceKeys = <String>{};

  static bool isValidImageUrl(String? url) {
    if (url == null || url.trim().isEmpty) {
      return false;
    }
    final uri = Uri.tryParse(url.trim());
    if (uri == null) {
      return false;
    }
    return (uri.scheme == 'http' || uri.scheme == 'https') &&
        uri.host.isNotEmpty;
  }

  static List<String> validImageUrls(Product product) {
    final images = product.images ?? <String>[];
    return images.where(isValidImageUrl).toList();
  }

  static String? primaryImageUrl(Product product) {
    final images = validImageUrls(product);
    if (images.isNotEmpty) {
      return images.first;
    }

    if (isValidImageUrl(product.thumbnail)) {
      return product.thumbnail;
    }

    return null;
  }

  static bool hasValidPrice(Product product) {
    final price = product.price;
    return price != null && price >= 0;
  }

  static String priceLabel(Product product) {
    if (!hasValidPrice(product)) {
      return 'Price unavailable';
    }
    return '\$${product.price!.toStringAsFixed(2)}';
  }

  static String displayTitle(Product product) {
    final title = product.title?.trim();
    return (title == null || title.isEmpty) ? 'Unnamed product' : title;
  }

  static String displayBrand(Product product) {
    final brand = product.brand?.trim();
    return (brand == null || brand.isEmpty) ? 'Unknown brand' : brand;
  }

  static String displayDescription(Product product) {
    final description = product.description?.trim();
    return (description == null || description.isEmpty)
        ? 'No description available.'
        : description;
  }

  static String displayCategory(Product product) {
    final category = product.category?.trim();
    return (category == null || category.isEmpty) ? 'Uncategorized' : category;
  }

  static void logImageWarningIfNeeded(
    Product product,
    AppLogger logger, {
    required String source,
  }) {
    if (primaryImageUrl(product) != null) {
      return;
    }
    final key = '$source:image:${_productKey(product)}';
    if (_warnedImageKeys.add(key)) {
      logger.warning(
        'Missing or invalid image URL. Rendering placeholder image.',
        className: source,
        methodName: 'render',
      );
    }
  }

  static void logImageLoadFailureIfNeeded(
    Product product,
    String imageUrl,
    AppLogger logger, {
    required String source,
  }) {
    final key = '$source:image_load:${_productKey(product)}:$imageUrl';
    if (_warnedImageLoadFailureKeys.add(key)) {
      logger.warning(
        'Failed to load product image URL. Rendering placeholder image.',
        className: source,
        methodName: 'render',
      );
    }
  }

  static void logPriceErrorIfNeeded(
    Product product,
    AppLogger logger, {
    required String source,
  }) {
    if (hasValidPrice(product)) {
      return;
    }
    final key = '$source:price:${_productKey(product)}';
    if (_erroredPriceKeys.add(key)) {
      logger.error(
        'Missing or negative price. Rendering "Price unavailable".',
        className: source,
        methodName: 'render',
      );
    }
  }

  static String _productKey(Product product) {
    if (product.id != null) {
      return product.id.toString();
    }
    final title = product.title?.trim();
    if (title != null && title.isNotEmpty) {
      return title;
    }
    return 'unknown';
  }
}
