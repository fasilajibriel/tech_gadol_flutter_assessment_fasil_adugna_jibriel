import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/core/constants/api_constants.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/core/error/failure.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/core/services/network/api_service.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/features/home/data/models/products_response_model/products_response_model.dart';

abstract class HomeRemoteDataSource {
  Future<ProductsResponseModel> getProducts({required int limit, required int skip});
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  HomeRemoteDataSourceImpl({required ApiService apiService}) : _apiService = apiService;

  final ApiService _apiService;

  @override
  Future<ProductsResponseModel> getProducts({required int limit, required int skip}) async {
    final response = await _apiService.get<Map<String, dynamic>>(
      endpoint: APIConstants.products,
      queryParams: <String, dynamic>{'limit': limit, 'skip': skip},
    );

    final payload = response.data;
    if (payload == null) {
      throw const DataParsingFailure(message: 'Products response payload is null.');
    }

    try {
      return ProductsResponseModel.fromMap(payload);
    } catch (error) {
      throw DataParsingFailure(message: 'Failed to parse products response payload.\n$error');
    }
  }
}
