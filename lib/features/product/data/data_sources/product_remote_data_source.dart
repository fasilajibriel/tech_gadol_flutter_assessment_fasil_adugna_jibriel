import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/core/constants/api_constants.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/core/error/failure.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/core/services/network/api_service.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/features/home/data/models/products_response_model/product.dart';

abstract class ProductRemoteDataSource {
  Future<Product> getProductById({required int id});
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  ProductRemoteDataSourceImpl({required ApiService apiService})
    : _apiService = apiService;

  final ApiService _apiService;

  @override
  Future<Product> getProductById({required int id}) async {
    final response = await _apiService.get<Map<String, dynamic>>(
      endpoint: APIConstants.productById(id),
    );

    final payload = response.data;
    if (payload == null) {
      throw const DataParsingFailure(message: 'Product details are empty.');
    }

    try {
      return Product.fromMap(payload);
    } catch (error) {
      throw DataParsingFailure(
        message: 'Failed to parse product details.\n$error',
      );
    }
  }
}
