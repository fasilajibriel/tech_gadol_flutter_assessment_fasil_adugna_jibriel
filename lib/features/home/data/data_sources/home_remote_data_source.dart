import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/core/constants/api_constants.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/core/error/failure.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/core/services/network/api_service.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/features/home/data/models/categories_respones_model/categories_respones_model.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/features/home/data/models/products_response_model/products_response_model.dart';

abstract class HomeRemoteDataSource {
  Future<ProductsResponseModel> getProducts({
    required int limit,
    required int skip,
  });

  Future<ProductsResponseModel> searchProducts({
    required String query,
    required int limit,
    required int skip,
  });

  Future<ProductsResponseModel> getProductsByCategory({
    required String category,
    required int limit,
    required int skip,
  });

  Future<List<CategoriesResponesModel>> getCategories();
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  HomeRemoteDataSourceImpl({required ApiService apiService})
    : _apiService = apiService;

  final ApiService _apiService;

  @override
  Future<ProductsResponseModel> getProducts({
    required int limit,
    required int skip,
  }) async {
    final response = await _apiService.get<Map<String, dynamic>>(
      endpoint: APIConstants.products,
      queryParams: <String, dynamic>{'limit': limit, 'skip': skip},
    );

    final payload = response.data;
    if (payload == null) {
      throw const DataParsingFailure(
        message: 'Products response payload is null.',
      );
    }

    try {
      return ProductsResponseModel.fromMap(payload);
    } catch (error) {
      throw DataParsingFailure(
        message: 'Failed to parse products response payload.\n$error',
      );
    }
  }

  @override
  Future<ProductsResponseModel> searchProducts({
    required String query,
    required int limit,
    required int skip,
  }) async {
    final response = await _apiService.get<Map<String, dynamic>>(
      endpoint: APIConstants.productSearch,
      queryParams: <String, dynamic>{'q': query, 'limit': limit, 'skip': skip},
    );

    final payload = response.data;
    if (payload == null) {
      throw const DataParsingFailure(
        message: 'Products response payload is null.',
      );
    }

    try {
      return ProductsResponseModel.fromMap(payload);
    } catch (error) {
      throw DataParsingFailure(
        message: 'Failed to parse products response payload.\n$error',
      );
    }
  }

  @override
  Future<ProductsResponseModel> getProductsByCategory({
    required String category,
    required int limit,
    required int skip,
  }) async {
    final response = await _apiService.get<Map<String, dynamic>>(
      endpoint: APIConstants.productsByCategory(category),
      queryParams: <String, dynamic>{'limit': limit, 'skip': skip},
    );

    final payload = response.data;
    if (payload == null) {
      throw const DataParsingFailure(
        message: 'Category products response payload is null.',
      );
    }

    try {
      return ProductsResponseModel.fromMap(payload);
    } catch (error) {
      throw DataParsingFailure(
        message: 'Failed to parse category products response payload.\n$error',
      );
    }
  }

  @override
  Future<List<CategoriesResponesModel>> getCategories() async {
    final response = await _apiService.get<dynamic>(
      endpoint: APIConstants.productCategories,
    );

    final payload = response.data;
    if (payload is! List) {
      throw const DataParsingFailure(
        message: 'Categories response payload is invalid.',
      );
    }

    try {
      return payload.map((item) {
        if (item is Map<String, dynamic>) {
          return CategoriesResponesModel.fromMap(item);
        }

        if (item is Map) {
          return CategoriesResponesModel.fromMap(
            Map<String, dynamic>.from(item),
          );
        }

        if (item is String) {
          return CategoriesResponesModel(slug: item, name: item, url: null);
        }

        throw const DataParsingFailure(
          message: 'Unsupported category item format.',
        );
      }).toList();
    } catch (error) {
      if (error is Failure) {
        rethrow;
      }
      throw DataParsingFailure(
        message: 'Failed to parse categories response payload.\n$error',
      );
    }
  }
}
