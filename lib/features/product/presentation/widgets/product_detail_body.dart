import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/core/constants/theme_constants.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/core/domain/app_logger.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/core/presentation/state/provider_view_state.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/di/injector.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/features/home/data/models/products_response_model/product.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/features/product/presentation/state/product_provider.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/shared/helpers/product_data_guard.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/shared/widgets/empty_state_widget.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/shared/widgets/error_state_widget.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/shared/widgets/initial_state_widget.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/shared/widgets/loading_state_widget.dart';

class ProductDetailBody extends StatefulWidget {
  const ProductDetailBody({
    super.key,
    required this.productId,
    this.embedded = false,
  });

  final int productId;
  final bool embedded;

  @override
  State<ProductDetailBody> createState() => _ProductDetailBodyState();
}

class _ProductDetailBodyState extends State<ProductDetailBody> {
  int _imageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductProvider>(
      builder: (context, provider, _) {
        final product = provider.product;
        if (product != null) {
          final logger = getIt<AppLogger>();
          ProductDataGuard.logImageWarningIfNeeded(
            product,
            logger,
            source: 'ProductDetailBody',
          );
          ProductDataGuard.logPriceErrorIfNeeded(
            product,
            logger,
            source: 'ProductDetailBody',
          );
        }
        final productImages = _resolveImages(product);

        return Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.5,
                color: Theme.of(context).colorScheme.surfaceContainerLowest,
                alignment: Alignment.topCenter,
                padding: EdgeInsets.only(
                  top: widget.embedded ? 28 : 120,
                  left: 24,
                  right: 24,
                  bottom: ThemeConstants.defaultPadding * 2,
                ),
                child: productImages.isEmpty
                    ? const Icon(EvaIcons.imageOutline, size: 120)
                    : Column(
                        children: [
                          Expanded(
                            child: PageView.builder(
                              itemCount: productImages.length,
                              onPageChanged: (index) {
                                setState(() {
                                  _imageIndex = index;
                                });
                              },
                              itemBuilder: (context, index) {
                                final imageUrl = productImages[index];
                                return Image.network(
                                  imageUrl,
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) {
                                    if (product != null) {
                                      final logger = getIt<AppLogger>();
                                      ProductDataGuard.logImageLoadFailureIfNeeded(
                                        product,
                                        imageUrl,
                                        logger,
                                        source: 'ProductDetailBody',
                                      );
                                    }
                                    return const Icon(
                                      Icons.broken_image,
                                      size: 120,
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                          if (productImages.length > 1) ...[
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(productImages.length, (
                                index,
                              ) {
                                final isActive = _imageIndex == index;
                                return AnimatedContainer(
                                  duration: const Duration(milliseconds: 220),
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 4,
                                  ),
                                  width: isActive ? 16 : 6,
                                  height: 6,
                                  decoration: BoxDecoration(
                                    color: isActive
                                        ? Theme.of(
                                            context,
                                          ).colorScheme.onSurface
                                        : Theme.of(
                                            context,
                                          ).colorScheme.onSurfaceVariant,
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                );
                              }),
                            ),
                          ],
                        ],
                      ),
              ),
            ),
            DraggableScrollableSheet(
              initialChildSize: 0.5,
              minChildSize: 0.5,
              maxChildSize: widget.embedded ? 0.95 : 0.75,
              builder: (context, scrollController) {
                return Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(28),
                    ),
                  ),
                  child: SingleChildScrollView(
                    controller: scrollController,
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Container(
                            width: 44,
                            height: 5,
                            decoration: BoxDecoration(
                              color: Theme.of(context).dividerColor,
                              borderRadius: BorderRadius.circular(100),
                            ),
                          ),
                        ),
                        const SizedBox(height: 18),
                        _buildSheetContent(provider),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  List<String> _resolveImages(Product? product) {
    if (product == null) {
      return <String>[];
    }

    final images = ProductDataGuard.validImageUrls(product);
    if (images.isNotEmpty) {
      return images;
    }

    final thumbnail = ProductDataGuard.primaryImageUrl(product);
    if (thumbnail != null) {
      return <String>[thumbnail];
    }

    return <String>[];
  }

  Widget _buildSheetContent(ProductProvider provider) {
    switch (provider.state) {
      case ProviderViewState.initial:
        return const InitialStateWidget(message: 'Preparing product...');
      case ProviderViewState.loading:
        return const LoadingStateWidget(message: 'Loading product...');
      case ProviderViewState.error:
        return ErrorStateWidget(
          message: provider.errorMessage ?? 'Failed to load product.',
          onRetry: () => provider.loadProduct(widget.productId),
        );
      case ProviderViewState.empty:
        return EmptyStateWidget(
          message: 'No product details available.',
          actionLabel: 'Retry',
          onAction: () => provider.loadProduct(widget.productId),
        );
      case ProviderViewState.loaded:
        final product = provider.product;
        if (product == null) {
          return EmptyStateWidget(
            message: 'No product details available.',
            actionLabel: 'Retry',
            onAction: () => provider.loadProduct(widget.productId),
          );
        }
        return _DetailsContent(product: product);
    }
  }
}

class _DetailsContent extends StatelessWidget {
  const _DetailsContent({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          ProductDataGuard.priceLabel(product),
          style: textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w700,
            color: ProductDataGuard.hasValidPrice(product)
                ? null
                : Theme.of(context).colorScheme.error,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          ProductDataGuard.displayTitle(product),
          style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        Text(
          ProductDataGuard.displayDescription(product),
          style: textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _InfoChip(
              label: 'Rating: ${(product.rating ?? 0).toStringAsFixed(1)}',
            ),
            _InfoChip(label: 'Stock: ${product.stock ?? 0}'),
            _InfoChip(
              label: 'Brand: ${ProductDataGuard.displayBrand(product)}',
            ),
            _InfoChip(
              label: 'Category: ${ProductDataGuard.displayCategory(product)}',
            ),
          ],
        ),
        if (product.tags != null && product.tags!.isNotEmpty) ...[
          const SizedBox(height: 16),
          Text('Tags', style: textTheme.titleMedium),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: product.tags!
                .map((tag) => Chip(label: Text(tag)))
                .toList(),
          ),
        ],
      ],
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(label),
    );
  }
}
