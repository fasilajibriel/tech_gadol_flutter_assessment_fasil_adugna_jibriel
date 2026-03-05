import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/core/helpers/typedef.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/features/home/data/models/products_response_model/products_response_model.dart';

abstract class HomeRepository {
  FutureResult<ProductsResponseModel> getProducts({
    required int limit,
    required int skip,
  });
}
