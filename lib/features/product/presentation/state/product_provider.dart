import 'package:flutter/foundation.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/core/error/failure_extensions.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/features/home/data/models/products_response_model/product.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/features/product/domain/usecases/get_product_by_id_use_case.dart';

class ProductProvider with ChangeNotifier {
  ProductProvider({required GetProductByIdUseCase getProductByIdUseCase})
    : _getProductByIdUseCase = getProductByIdUseCase;

  final GetProductByIdUseCase _getProductByIdUseCase;

  bool _isLoading = false;
  String? _errorMessage;
  Product? _product;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  Product? get product => _product;

  Future<void> loadProduct(int id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _getProductByIdUseCase(GetProductByIdParams(id: id));
    result.fold(
      (failure) {
        _errorMessage = failure.userMessage;
      },
      (product) {
        _product = product;
        _errorMessage = null;
      },
    );

    _isLoading = false;
    notifyListeners();
  }
}
