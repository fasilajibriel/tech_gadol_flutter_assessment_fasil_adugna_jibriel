import 'package:flutter/foundation.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/core/error/failure_extensions.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/core/helpers/typedef.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/core/helpers/usecase.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/core/presentation/state/provider_view_state.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/features/home/data/models/categories_respones_model/categories_respones_model.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/features/home/data/models/products_response_model/product.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/features/home/data/models/products_response_model/products_response_model.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/features/home/domain/usecases/get_categories_use_case.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/features/home/domain/usecases/get_products_by_category_use_case.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/features/home/domain/usecases/get_products_use_case.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/features/home/domain/usecases/search_products_use_case.dart';

class HomeProvider with ChangeNotifier {
  static const String allCategory = 'All';

  HomeProvider({
    required GetProductsUseCase getProductsUseCase,
    required SearchProductsUseCase searchProductsUseCase,
    required GetProductsByCategoryUseCase getProductsByCategoryUseCase,
    required GetCategoriesUseCase getCategoriesUseCase,
  }) : _getProductsUseCase = getProductsUseCase,
       _searchProductsUseCase = searchProductsUseCase,
       _getProductsByCategoryUseCase = getProductsByCategoryUseCase,
       _getCategoriesUseCase = getCategoriesUseCase;

  final GetProductsUseCase _getProductsUseCase;
  final SearchProductsUseCase _searchProductsUseCase;
  final GetProductsByCategoryUseCase _getProductsByCategoryUseCase;
  final GetCategoriesUseCase _getCategoriesUseCase;

  bool _isLoading = false;
  bool _isLoadingMore = false;
  bool _isCategoriesLoading = false;
  ProviderViewState _productsState = ProviderViewState.initial;
  ProviderViewState _categoriesState = ProviderViewState.initial;
  bool _hasMore = true;
  int _limit = 20;
  int _page = 0;
  int _requestCounter = 0;
  String? _errorMessage;
  String? _categoriesErrorMessage;
  ProductsResponseModel? _productsResponseModel;
  List<Product> _products = <Product>[];
  List<CategoriesResponesModel> _categories = <CategoriesResponesModel>[];
  String _searchQuery = '';
  String _appliedSearchQuery = '';
  String _selectedCategorySlug = allCategory;

  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
  bool get isCategoriesLoading => _isCategoriesLoading;
  bool get hasMore => _hasMore;
  ProviderViewState get productsState => _productsState;
  ProviderViewState get categoriesState => _categoriesState;
  String? get errorMessage => _errorMessage;
  String? get categoriesErrorMessage => _categoriesErrorMessage;
  int get limit => _limit;
  int get page => _page;
  String get searchQuery => _searchQuery;
  String get appliedSearchQuery => _appliedSearchQuery;
  String get selectedCategorySlug => _selectedCategorySlug;
  List<CategoriesResponesModel> get categories => _categories;

  List<Product> get filteredProducts {
    final query = _appliedSearchQuery.trim().toLowerCase();
    return _products.where((product) {
      final title = (product.title ?? '').toLowerCase();
      final category = product.category ?? '';

      final matchesSearch = query.isEmpty || title.contains(query);
      final matchesCategory =
          _selectedCategorySlug == allCategory ||
          category == _selectedCategorySlug;

      return matchesSearch && matchesCategory;
    }).toList();
  }

  // Casted and stored data from /products endpoint for UI consumption.
  ProductsResponseModel? get productsResponseModel => _productsResponseModel;
  List<Product> get products => _products;

  Future<void> initialize() async {
    await Future.wait([loadCategories(), loadInitialProducts(limit: _limit)]);
  }

  void setSearchQuery(String value) {
    _searchQuery = value;
    notifyListeners();
  }

  Future<void> applySearch() async {
    _appliedSearchQuery = _searchQuery.trim();
    await loadInitialProducts(limit: _limit);
  }

  Future<void> setSelectedCategory(String value) async {
    _selectedCategorySlug = value;
    notifyListeners();
    await loadInitialProducts(limit: _limit);
  }

  Future<void> loadCategories() async {
    _categoriesErrorMessage = null;
    _categoriesState = ProviderViewState.loading;
    _isCategoriesLoading = true;
    notifyListeners();

    final result = await _getCategoriesUseCase(NoParams());

    result.fold(
      (failure) {
        _categoriesErrorMessage = failure.userMessage;
        _categoriesState = ProviderViewState.error;
      },
      (categoryModels) {
        _categories = categoryModels;
        _categoriesErrorMessage = null;
        _categoriesState = _categories.isEmpty
            ? ProviderViewState.empty
            : ProviderViewState.loaded;

        if (_selectedCategorySlug != allCategory &&
            !_categories.any(
              (category) =>
                  (category.slug ?? category.name ?? '') ==
                  _selectedCategorySlug,
            )) {
          _selectedCategorySlug = allCategory;
        }
      },
    );

    _isCategoriesLoading = false;
    notifyListeners();
  }

  Future<void> loadInitialProducts({int limit = 10}) async {
    _limit = limit;
    _page = 0;
    _hasMore = true;
    _errorMessage = null;
    _products = <Product>[];
    _productsResponseModel = null;
    _productsState = ProviderViewState.loading;
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
    final requestId = ++_requestCounter;

    if (isInitialLoad) {
      _isLoading = true;
      _productsState = ProviderViewState.loading;
    } else {
      _isLoadingMore = true;
    }
    notifyListeners();

    final skip = _page * _limit;
    final result = await _resolveProductsRequest(limit: _limit, skip: skip);

    if (requestId != _requestCounter) {
      return;
    }

    result.fold(
      (failure) {
        _errorMessage = failure.userMessage;
        if (isInitialLoad || _products.isEmpty) {
          _productsState = ProviderViewState.error;
        }
      },
      (responseModel) {
        _errorMessage = null;
        _productsResponseModel = responseModel;

        final fetchedProducts = responseModel.products ?? <Product>[];
        _products = isInitialLoad
            ? fetchedProducts
            : <Product>[..._products, ...fetchedProducts];

        final total = responseModel.total ?? _products.length;
        _hasMore = _products.length < total && fetchedProducts.isNotEmpty;
        _productsState = _products.isEmpty
            ? ProviderViewState.empty
            : ProviderViewState.loaded;

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

  FutureResult<ProductsResponseModel> _resolveProductsRequest({
    required int limit,
    required int skip,
  }) {
    if (_selectedCategorySlug != allCategory) {
      return _getProductsByCategoryUseCase(
        GetProductsByCategoryParams(
          category: _selectedCategorySlug,
          limit: limit,
          skip: skip,
        ),
      );
    }

    final query = _appliedSearchQuery.trim();
    if (query.isNotEmpty) {
      return _searchProductsUseCase(
        SearchProductsParams(query: query, limit: limit, skip: skip),
      );
    }

    return _getProductsUseCase(GetProductsParams(limit: limit, skip: skip));
  }
}
