import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/core/constants/theme_constants.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/core/presentation/providers/theme_provider.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/features/home/data/models/products_response_model/product.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback? onTap;

  const ProductCard({super.key, required this.product, this.onTap});

  @override
  Widget build(BuildContext context) {
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
      child: Image.network(
        product.thumbnail ?? "",
        fit: BoxFit.contain, // Best for isolating products
        errorBuilder: (context, error, stackTrace) =>
            const Icon(Icons.shopping_bag_outlined),
      ),
    );
  }

  Widget _buildDetails(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        Text(
          product.title ?? "",
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        // Simplified Info (Brand only for compact view)
        Text(
          "By: ${product.brand}",
          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
        ),
        const Spacer(),
        // Simplified Price (Mapped directly from JSON price)
        Text(
          '\$${product.price?.toStringAsFixed(2)}',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
