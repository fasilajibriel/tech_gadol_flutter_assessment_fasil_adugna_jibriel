import 'package:flutter/foundation.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/core/error/failure_extensions.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/core/presentation/state/provider_view_state.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/features/home/data/models/products_response_model/product.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/features/product/domain/usecases/get_product_by_id_use_case.dart';

class ProductProvider with ChangeNotifier {
  ProductProvider({required GetProductByIdUseCase getProductByIdUseCase})
    : _getProductByIdUseCase = getProductByIdUseCase;

  final GetProductByIdUseCase _getProductByIdUseCase;

  bool _isLoading = false;
  String? _errorMessage;
  Product? _product;
  ProviderViewState _state = ProviderViewState.initial;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  Product? get product => _product;
  ProviderViewState get state => _state;

  Future<void> loadProduct(int id) async {
    _isLoading = true;
    _errorMessage = null;
    _state = ProviderViewState.loading;
    notifyListeners();

    final result = await _getProductByIdUseCase(GetProductByIdParams(id: id));
    result.fold(
      (failure) {
        _errorMessage = failure.userMessage;
        _state = ProviderViewState.error;
      },
      (product) {
        _product = product;
        _errorMessage = null;
        _state = _product == null
            ? ProviderViewState.empty
            : ProviderViewState.loaded;
      },
    );

    _isLoading = false;
    notifyListeners();
  }
}
