import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/core/helpers/usecase.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/core/helpers/typedef.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/features/home/data/models/products_response_model/products_response_model.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/features/home/domain/repositories/home_repository.dart';

class GetProductsParams {
  final int limit;
  final int skip;

  const GetProductsParams({required this.limit, required this.skip});
}

class GetProductsUseCase
    implements UseCase<ProductsResponseModel, GetProductsParams> {
  GetProductsUseCase({required HomeRepository homeRepository})
    : _homeRepository = homeRepository;

  final HomeRepository _homeRepository;

  @override
  FutureResult<ProductsResponseModel> call(GetProductsParams params) {
    return _homeRepository.getProducts(limit: params.limit, skip: params.skip);
  }
}
