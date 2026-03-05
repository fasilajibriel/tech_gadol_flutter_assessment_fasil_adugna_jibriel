import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/core/helpers/typedef.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/core/helpers/usecase.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/features/home/data/models/products_response_model/products_response_model.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/features/home/domain/repositories/home_repository.dart';

class GetProductsByCategoryParams {
  final String category;
  final int limit;
  final int skip;

  const GetProductsByCategoryParams({
    required this.category,
    required this.limit,
    required this.skip,
  });
}

class GetProductsByCategoryUseCase
    implements UseCase<ProductsResponseModel, GetProductsByCategoryParams> {
  GetProductsByCategoryUseCase({required HomeRepository homeRepository})
    : _homeRepository = homeRepository;

  final HomeRepository _homeRepository;

  @override
  FutureResult<ProductsResponseModel> call(GetProductsByCategoryParams params) {
    return _homeRepository.getProductsByCategory(
      category: params.category,
      limit: params.limit,
      skip: params.skip,
    );
  }
}
