import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/core/helpers/typedef.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/core/helpers/usecase.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/features/home/data/models/categories_respones_model/categories_respones_model.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/features/home/domain/repositories/home_repository.dart';

class GetCategoriesUseCase
    implements UseCase<List<CategoriesResponesModel>, NoParams> {
  GetCategoriesUseCase({required HomeRepository homeRepository})
    : _homeRepository = homeRepository;

  final HomeRepository _homeRepository;

  @override
  FutureResult<List<CategoriesResponesModel>> call(NoParams params) {
    return _homeRepository.getCategories();
  }
}
