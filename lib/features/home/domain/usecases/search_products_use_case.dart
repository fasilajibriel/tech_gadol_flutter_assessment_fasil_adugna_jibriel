import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/core/helpers/typedef.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/core/helpers/usecase.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/features/home/data/models/products_response_model/products_response_model.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/features/home/domain/repositories/home_repository.dart';

class SearchProductsParams {
  final String query;
  final int limit;
  final int skip;

  const SearchProductsParams({
    required this.query,
    required this.limit,
    required this.skip,
  });
}

class SearchProductsUseCase
    implements UseCase<ProductsResponseModel, SearchProductsParams> {
  SearchProductsUseCase({required HomeRepository homeRepository})
    : _homeRepository = homeRepository;

  final HomeRepository _homeRepository;

  @override
  FutureResult<ProductsResponseModel> call(SearchProductsParams params) {
    return _homeRepository.searchProducts(
      query: params.query,
      limit: params.limit,
      skip: params.skip,
    );
  }
}
