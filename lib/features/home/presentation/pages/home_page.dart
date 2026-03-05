import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/app/routes.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/core/presentation/providers/theme_provider.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/core/presentation/state/provider_view_state.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/di/injector.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/features/home/data/models/products_response_model/product.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/features/home/presentation/state/home_provider.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/features/product/presentation/state/product_provider.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/features/product/presentation/widgets/product_detail_body.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/shared/widgets/category_chip.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/shared/widgets/empty_state_widget.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/shared/widgets/error_state_widget.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/shared/widgets/initial_state_widget.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/shared/widgets/loading_state_widget.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/shared/widgets/product_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final ScrollController _scrollController;
  late final TextEditingController _searchController;
  late final ProductProvider _productDetailProvider;
  int? _selectedProductId;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
    _searchController = TextEditingController();
    _productDetailProvider = getIt<ProductProvider>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeProvider>().initialize();
    });
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    _searchController.dispose();
    _productDetailProvider.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) {
      return;
    }
    final threshold = _scrollController.position.maxScrollExtent - 200;
    if (_scrollController.position.pixels >= threshold) {
      context.read<HomeProvider>().loadMoreProducts();
    }
  }

  void _onSearchChanged(String value) {
    context.read<HomeProvider>().setSearchQuery(value);
  }

  Future<void> _onSearchSubmitted() async {
    await context.read<HomeProvider>().applySearch();
    if (mounted) {
      FocusScope.of(context).unfocus();
    }
  }

  void _onProductTap(Product product, bool isWideScreen) {
    final productId = product.id;
    if (productId == null) {
      return;
    }

    if (isWideScreen) {
      setState(() {
        _selectedProductId = productId;
      });
      _productDetailProvider.loadProduct(productId);
      return;
    }

    context.push(Routes.product.pathFromId(productId));
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final isDarkMode =
        themeProvider.themeMode == ThemeMode.dark ||
        (themeProvider.themeMode == ThemeMode.system &&
            Theme.of(context).brightness == Brightness.dark);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            tooltip: isDarkMode
                ? 'Switch to light mode'
                : 'Switch to dark mode',
            onPressed: () {
              context.read<ThemeProvider>().toggleTheme();
            },
            icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode),
          ),
        ],
      ),
      body: Consumer<HomeProvider>(
        builder: (context, provider, _) {
          return LayoutBuilder(
            builder: (context, constraints) {
              final isWideScreen = constraints.maxWidth >= 768;
              if (!isWideScreen) {
                return _buildListPanel(provider, isWideScreen: false);
              }

              final leftPanelWidth = constraints.maxWidth >= 1200
                  ? 400.0
                  : 360.0;
              return Row(
                children: [
                  SizedBox(
                    width: leftPanelWidth,
                    child: _buildListPanel(provider, isWideScreen: true),
                  ),
                  const VerticalDivider(width: 1),
                  Expanded(
                    child: _selectedProductId == null
                        ? const EmptyStateWidget(
                            message: 'Select a product to view details.',
                          )
                        : ChangeNotifierProvider<ProductProvider>.value(
                            value: _productDetailProvider,
                            child: ProductDetailBody(
                              key: ValueKey<int>(_selectedProductId!),
                              productId: _selectedProductId!,
                              embedded: true,
                            ),
                          ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildListPanel(HomeProvider provider, {required bool isWideScreen}) {
    final filteredProducts = provider.filteredProducts;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
          child: SearchBar(
            controller: _searchController,
            hintText: 'Search products',
            onChanged: _onSearchChanged,
            onSubmitted: (_) => _onSearchSubmitted(),
            trailing: [
              IconButton(
                onPressed: () {
                  _onSearchSubmitted();
                },
                icon: const Icon(Icons.search),
              ),
              if (provider.searchQuery.isNotEmpty)
                IconButton(
                  onPressed: () {
                    _searchController.clear();
                    _onSearchChanged('');
                    _onSearchSubmitted();
                  },
                  icon: const Icon(Icons.clear),
                ),
            ],
          ),
        ),
        _buildCategorySection(provider),
        const SizedBox(height: 8),
        Expanded(
          child: RefreshIndicator(
            onRefresh: provider.refreshProducts,
            child: _buildProductSection(
              provider,
              filteredProducts,
              isWideScreen: isWideScreen,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCategorySection(HomeProvider provider) {
    switch (provider.categoriesState) {
      case ProviderViewState.initial:
        return const SizedBox(
          height: 48,
          child: InitialStateWidget(
            compact: true,
            message: 'Preparing categories...',
          ),
        );
      case ProviderViewState.loading:
        return const SizedBox(
          height: 48,
          child: LoadingStateWidget(compact: true),
        );
      case ProviderViewState.error:
        return SizedBox(
          height: 48,
          child: ErrorStateWidget(
            compact: true,
            message:
                provider.categoriesErrorMessage ?? 'Failed to load categories',
            onRetry: provider.loadCategories,
          ),
        );
      case ProviderViewState.empty:
        return const SizedBox(
          height: 48,
          child: EmptyStateWidget(
            compact: true,
            message: 'No categories found.',
          ),
        );
      case ProviderViewState.loaded:
        return SizedBox(
          height: 48,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            scrollDirection: Axis.horizontal,
            itemCount: provider.categories.length + 1,
            separatorBuilder: (_, _) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              if (index == 0) {
                return CategoryChip(
                  label: HomeProvider.allCategory,
                  isSelected:
                      provider.selectedCategorySlug == HomeProvider.allCategory,
                  onTap: () =>
                      provider.setSelectedCategory(HomeProvider.allCategory),
                );
              }

              final category = provider.categories[index - 1];
              final categorySlug = category.slug ?? category.name ?? '';
              final categoryName = category.name ?? categorySlug;

              return CategoryChip(
                label: categoryName,
                isSelected: provider.selectedCategorySlug == categorySlug,
                onTap: () => provider.setSelectedCategory(categorySlug),
              );
            },
          ),
        );
    }
  }

  Widget _buildProductSection(
    HomeProvider provider,
    List<Product> filteredProducts, {
    required bool isWideScreen,
  }) {
    switch (provider.productsState) {
      case ProviderViewState.initial:
        return _buildScrollableState(
          const InitialStateWidget(
            message: 'Enter search or select a category.',
          ),
        );
      case ProviderViewState.loading:
        return _buildScrollableState(
          const LoadingStateWidget(message: 'Loading products...'),
        );
      case ProviderViewState.error:
        return _buildScrollableState(
          ErrorStateWidget(
            message: provider.errorMessage ?? 'Failed to load products.',
            onRetry: provider.refreshProducts,
          ),
        );
      case ProviderViewState.empty:
        return _buildScrollableState(
          EmptyStateWidget(
            message: 'No products found.',
            actionLabel: 'Refresh',
            onAction: provider.refreshProducts,
          ),
        );
      case ProviderViewState.loaded:
        return ListView.builder(
          controller: _scrollController,
          itemCount: filteredProducts.length + (provider.isLoadingMore ? 1 : 0),
          itemBuilder: (context, index) {
            if (index >= filteredProducts.length) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Center(child: CircularProgressIndicator()),
              );
            }

            final product = filteredProducts[index];
            return Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
              child: ProductCard(
                product: product,
                onTap: () => _onProductTap(product, isWideScreen),
              ),
            );
          },
        );
    }
  }

  Widget _buildScrollableState(Widget child) {
    return ListView(
      controller: _scrollController,
      children: [const SizedBox(height: 120), child],
    );
  }
}
