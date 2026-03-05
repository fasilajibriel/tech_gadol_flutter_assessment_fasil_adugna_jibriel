import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/core/helpers/typedef.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/core/helpers/usecase.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/features/home/data/models/products_response_model/product.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/features/product/domain/repositories/product_repository.dart';

class GetProductByIdParams {
  final int id;

  const GetProductByIdParams({required this.id});
}

class GetProductByIdUseCase implements UseCase<Product, GetProductByIdParams> {
  GetProductByIdUseCase({required ProductRepository repository})
    : _repository = repository;

  final ProductRepository _repository;

  @override
  FutureResult<Product> call(GetProductByIdParams params) {
    return _repository.getProductById(id: params.id);
  }
}
