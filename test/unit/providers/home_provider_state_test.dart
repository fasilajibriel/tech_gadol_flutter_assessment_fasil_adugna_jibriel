import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/core/error/failure.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/core/helpers/typedef.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/core/presentation/state/provider_view_state.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/features/home/data/models/categories_respones_model/categories_respones_model.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/features/home/data/models/products_response_model/product.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/features/home/data/models/products_response_model/products_response_model.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/features/home/domain/repositories/home_repository.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/features/home/domain/usecases/get_categories_use_case.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/features/home/domain/usecases/get_products_by_category_use_case.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/features/home/domain/usecases/get_products_use_case.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/features/home/domain/usecases/search_products_use_case.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/features/home/presentation/state/home_provider.dart';

class _FakeHomeRepository implements HomeRepository {
  FutureResult<ProductsResponseModel> productsResult = Future.value(
    Right(
      const ProductsResponseModel(
        products: [Product(id: 1, title: 'Phone', category: 'smartphones')],
        total: 1,
        skip: 0,
        limit: 20,
      ),
    ),
  );
  FutureResult<ProductsResponseModel> searchResult = Future.value(
    Right(const ProductsResponseModel(products: [], total: 0, skip: 0, limit: 20)),
  );
  FutureResult<ProductsResponseModel> categoryResult = Future.value(
    Right(const ProductsResponseModel(products: [], total: 0, skip: 0, limit: 20)),
  );
  FutureResult<List<CategoriesResponesModel>> categoriesResult = Future.value(
    const Right([CategoriesResponesModel(slug: 'smartphones', name: 'Smartphones')]),
  );

  String? lastMethod;

  @override
  FutureResult<ProductsResponseModel> getProducts({
    required int limit,
    required int skip,
  }) {
    lastMethod = 'getProducts';
    return productsResult;
  }

  @override
  FutureResult<ProductsResponseModel> searchProducts({
    required String query,
    required int limit,
    required int skip,
  }) {
    lastMethod = 'searchProducts';
    return searchResult;
  }

  @override
  FutureResult<ProductsResponseModel> getProductsByCategory({
    required String category,
    required int limit,
    required int skip,
  }) {
    lastMethod = 'getProductsByCategory';
    return categoryResult;
  }

  @override
  FutureResult<List<CategoriesResponesModel>> getCategories() {
    lastMethod = 'getCategories';
    return categoriesResult;
  }
}

void main() {
  late _FakeHomeRepository fakeRepository;
  late HomeProvider provider;

  setUp(() {
    fakeRepository = _FakeHomeRepository();
    provider = HomeProvider(
      getProductsUseCase: GetProductsUseCase(homeRepository: fakeRepository),
      searchProductsUseCase: SearchProductsUseCase(homeRepository: fakeRepository),
      getProductsByCategoryUseCase: GetProductsByCategoryUseCase(homeRepository: fakeRepository),
      getCategoriesUseCase: GetCategoriesUseCase(homeRepository: fakeRepository),
    );
  });

  test('starts in initial state', () {
    expect(provider.productsState, ProviderViewState.initial);
    expect(provider.categoriesState, ProviderViewState.initial);
  });

  test('loadInitialProducts success transitions to loaded', () async {
    await provider.loadInitialProducts(limit: 20);

    expect(provider.productsState, ProviderViewState.loaded);
    expect(provider.products.length, 1);
  });

  test('loadInitialProducts empty transitions to empty', () async {
    fakeRepository.productsResult = Future.value(
      const Right(ProductsResponseModel(products: [], total: 0, skip: 0, limit: 20)),
    );

    await provider.loadInitialProducts(limit: 20);

    expect(provider.productsState, ProviderViewState.empty);
  });

  test('loadInitialProducts failure transitions to error', () async {
    fakeRepository.productsResult = Future.value(
      const Left(NetworkFailure(message: 'No internet')),
    );

    await provider.loadInitialProducts(limit: 20);

    expect(provider.productsState, ProviderViewState.error);
  });

  test('loadCategories success transitions to loaded', () async {
    await provider.loadCategories();

    expect(provider.categoriesState, ProviderViewState.loaded);
    expect(provider.categories.length, 1);
  });

  test('search submits through search endpoint', () async {
    provider.setSearchQuery('phone');
    fakeRepository.searchResult = Future.value(
      Right(
        const ProductsResponseModel(
          products: [Product(id: 7, title: 'Phone X', category: 'smartphones')],
          total: 1,
          skip: 0,
          limit: 20,
        ),
      ),
    );

    await provider.applySearch();

    expect(fakeRepository.lastMethod, 'searchProducts');
    expect(provider.productsState, ProviderViewState.loaded);
  });
}
