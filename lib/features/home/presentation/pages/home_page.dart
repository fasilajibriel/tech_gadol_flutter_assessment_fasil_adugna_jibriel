import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/core/presentation/providers/theme_provider.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/features/home/presentation/state/home_provider.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/shared/widgets/category_chip.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/shared/widgets/product_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final ScrollController _scrollController;
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
    _searchController = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final homeProvider = context.read<HomeProvider>();
      if (homeProvider.products.isEmpty && !homeProvider.isLoading) {
        homeProvider.loadInitialProducts();
      }
    });
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    _searchController.dispose();
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

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final isDarkMode =
        themeProvider.themeMode == ThemeMode.dark ||
        (themeProvider.themeMode == ThemeMode.system && Theme.of(context).brightness == Brightness.dark);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            tooltip: isDarkMode ? 'Switch to light mode' : 'Switch to dark mode',
            onPressed: () {
              context.read<ThemeProvider>().toggleTheme();
            },
            icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode),
          ),
        ],
      ),
      body: Consumer<HomeProvider>(
        builder: (context, provider, _) {
          final filteredProducts = provider.filteredProducts;

          if (provider.isLoading && provider.products.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.errorMessage != null && provider.products.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(provider.errorMessage!),
                  const SizedBox(height: 12),
                  ElevatedButton(onPressed: provider.refreshProducts, child: const Text('Retry')),
                ],
              ),
            );
          }

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
                child: SearchBar(
                  controller: _searchController,
                  hintText: 'Search products',
                  leading: const Icon(Icons.search),
                  onChanged: provider.setSearchQuery,
                  trailing: [
                    if (provider.searchQuery.isNotEmpty)
                      IconButton(
                        onPressed: () {
                          _searchController.clear();
                          provider.setSearchQuery('');
                        },
                        icon: const Icon(Icons.clear),
                      ),
                  ],
                ),
              ),
              SizedBox(
                height: 48,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  scrollDirection: Axis.horizontal,
                  itemCount: provider.categories.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final category = provider.categories[index];
                    return CategoryChip(
                      label: category,
                      isSelected: provider.selectedCategory == category,
                      onTap: () => provider.setSelectedCategory(category),
                    );
                  },
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: provider.refreshProducts,
                  child: ListView.builder(
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
                        child: ProductCard(product: product),
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
