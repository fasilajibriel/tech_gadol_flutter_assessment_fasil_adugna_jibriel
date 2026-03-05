import 'package:flutter/foundation.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/core/error/failure_extensions.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/features/home/data/models/products_response_model/product.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/features/home/data/models/products_response_model/products_response_model.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/features/home/domain/usecases/get_products_use_case.dart';

class HomeProvider with ChangeNotifier {
  static const String allCategory = 'All';

  HomeProvider({required GetProductsUseCase getProductsUseCase})
    : _getProductsUseCase = getProductsUseCase;

  final GetProductsUseCase _getProductsUseCase;

  bool _isLoading = false;
  bool _isLoadingMore = false;
  bool _hasMore = true;
  int _limit = 10;
  int _page = 0;
  String? _errorMessage;
  ProductsResponseModel? _productsResponseModel;
  List<Product> _products = <Product>[];
  String _searchQuery = '';
  String _selectedCategory = allCategory;

  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
  bool get hasMore => _hasMore;
  String? get errorMessage => _errorMessage;
  int get limit => _limit;
  int get page => _page;
  String get searchQuery => _searchQuery;
  String get selectedCategory => _selectedCategory;
  List<String> get categories {
    final sortedCategories =
        _products
            .map((product) => product.category?.trim() ?? '')
            .where((category) => category.isNotEmpty)
            .toSet()
            .toList()
          ..sort();
    return <String>[allCategory, ...sortedCategories];
  }

  List<Product> get filteredProducts {
    final query = _searchQuery.trim().toLowerCase();
    return _products.where((product) {
      final title = (product.title ?? '').toLowerCase();
      final category = product.category ?? '';

      final matchesSearch = query.isEmpty || title.contains(query);
      final matchesCategory =
          _selectedCategory == allCategory || category == _selectedCategory;

      return matchesSearch && matchesCategory;
    }).toList();
  }

  // Casted and stored data from /products endpoint for UI consumption.
  ProductsResponseModel? get productsResponseModel => _productsResponseModel;
  List<Product> get products => _products;

  void setSearchQuery(String value) {
    _searchQuery = value;
    notifyListeners();
  }

  void setSelectedCategory(String value) {
    _selectedCategory = value;
    notifyListeners();
  }

  Future<void> loadInitialProducts({int limit = 10}) async {
    _limit = limit;
    _page = 0;
    _hasMore = true;
    _errorMessage = null;
    _products = <Product>[];
    _productsResponseModel = null;
    await _fetchProducts(isInitialLoad: true);
  }

  Future<void> loadMoreProducts() async {
    if (_isLoading || _isLoadingMore || !_hasMore) {
      return;
    }

    await _fetchProducts(isInitialLoad: false);
  }

  Future<void> refreshProducts() async {
    await loadInitialProducts(limit: _limit);
  }

  Future<void> _fetchProducts({required bool isInitialLoad}) async {
    if (isInitialLoad) {
      _isLoading = true;
    } else {
      _isLoadingMore = true;
    }
    notifyListeners();

    final skip = _page * _limit;
    final result = await _getProductsUseCase(
      GetProductsParams(limit: _limit, skip: skip),
    );

    result.fold(
      (failure) {
        _errorMessage = failure.userMessage;
      },
      (responseModel) {
        _errorMessage = null;
        _productsResponseModel = responseModel;

        final fetchedProducts = responseModel.products ?? <Product>[];
        _products = isInitialLoad
            ? fetchedProducts
            : <Product>[..._products, ...fetchedProducts];

        if (_selectedCategory != allCategory &&
            !categories.contains(_selectedCategory)) {
          _selectedCategory = allCategory;
        }

        final total = responseModel.total ?? _products.length;
        _hasMore = _products.length < total && fetchedProducts.isNotEmpty;

        if (fetchedProducts.isNotEmpty) {
          _page += 1;
        }
      },
    );

    if (isInitialLoad) {
      _isLoading = false;
    } else {
      _isLoadingMore = false;
    }
    notifyListeners();
  }
}
