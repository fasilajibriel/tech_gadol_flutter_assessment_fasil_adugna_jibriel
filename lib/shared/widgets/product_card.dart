import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/core/constants/theme_constants.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/core/domain/app_logger.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/core/presentation/providers/theme_provider.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/di/injector.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/features/home/data/models/products_response_model/product.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/shared/helpers/product_data_guard.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback? onTap;

  const ProductCard({super.key, required this.product, this.onTap});

  @override
  Widget build(BuildContext context) {
    final logger = getIt<AppLogger>();
    ProductDataGuard.logImageWarningIfNeeded(
      product,
      logger,
      source: 'ProductCard',
    );
    ProductDataGuard.logPriceErrorIfNeeded(
      product,
      logger,
      source: 'ProductCard',
    );

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: context.read<ThemeProvider>().themeMode == ThemeMode.dark
                ? ThemeConstants.darkCardBgColor
                : ThemeConstants.lightCardBgColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: IntrinsicHeight(
            child: Row(
              children: [
                _buildImage(context),
                const SizedBox(width: 16),
                Expanded(child: _buildDetails(context)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Sub-widgets for layout clarity and performance

  Widget _buildImage(BuildContext context) {
    final imageUrl = ProductDataGuard.primaryImageUrl(product);
    return Container(
      width: 72,
      height: 72,
      decoration: BoxDecoration(
        color: context.read<ThemeProvider>().themeMode == ThemeMode.dark
            ? ThemeConstants.darkCardBgColor
            : ThemeConstants.lightCardBgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      clipBehavior: Clip.antiAlias,
      child: imageUrl == null
          ? const Icon(Icons.image_not_supported)
          : Image.network(
              imageUrl,
              fit: BoxFit.contain, // Best for isolating products
              errorBuilder: (context, error, stackTrace) {
                final logger = getIt<AppLogger>();
                ProductDataGuard.logImageLoadFailureIfNeeded(
                  product,
                  imageUrl,
                  logger,
                  source: 'ProductCard',
                );
                return const Icon(Icons.shopping_bag_outlined);
              },
            ),
    );
  }

  Widget _buildDetails(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        Text(
          ProductDataGuard.displayTitle(product),
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Text(
          'By: ${ProductDataGuard.displayBrand(product)}',
          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
        ),
        const Spacer(),
        Text(
          ProductDataGuard.priceLabel(product),
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: ProductDataGuard.hasValidPrice(product)
                ? null
                : Colors.redAccent,
          ),
        ),
      ],
    );
  }

  // Widget _buildQuantity() {
  //   return Align(
  //     alignment: Alignment.center,
  //     child: Padding(
  //       padding: const EdgeInsets.only(left: 12.0),
  //       child: Text('x$quantity', style: TextStyle(fontSize: 14, color: Colors.grey[600])),
  //     ),
  //   );
  // }
}
