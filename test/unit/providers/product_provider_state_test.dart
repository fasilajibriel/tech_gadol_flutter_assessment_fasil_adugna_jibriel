import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/core/error/failure.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/core/helpers/typedef.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/core/presentation/state/provider_view_state.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/features/home/data/models/products_response_model/product.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/features/product/domain/repositories/product_repository.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/features/product/domain/usecases/get_product_by_id_use_case.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/features/product/presentation/state/product_provider.dart';

class _FakeProductRepository implements ProductRepository {
  FutureResult<Product> result = Future.value(
    const Right(Product(id: 1, title: 'Phone', price: 199.99)),
  );
  int? lastRequestedId;

  @override
  FutureResult<Product> getProductById({required int id}) {
    lastRequestedId = id;
    return result;
  }
}

void main() {
  late _FakeProductRepository fakeRepository;
  late ProductProvider provider;

  setUp(() {
    fakeRepository = _FakeProductRepository();
    provider = ProductProvider(
      getProductByIdUseCase: GetProductByIdUseCase(repository: fakeRepository),
    );
  });

  test('starts in initial state', () {
    expect(provider.state, ProviderViewState.initial);
    expect(provider.product, isNull);
    expect(provider.errorMessage, isNull);
    expect(provider.isLoading, isFalse);
  });

  test('loadProduct transitions loading -> loaded on success', () async {
    final states = <ProviderViewState>[];
    provider.addListener(() {
      states.add(provider.state);
    });

    final pending = provider.loadProduct(42);

    expect(provider.state, ProviderViewState.loading);
    expect(provider.isLoading, isTrue);

    await pending;

    expect(fakeRepository.lastRequestedId, 42);
    expect(provider.state, ProviderViewState.loaded);
    expect(provider.isLoading, isFalse);
    expect(provider.product?.id, 1);
    expect(provider.errorMessage, isNull);
    expect(
      states,
      containsAllInOrder([ProviderViewState.loading, ProviderViewState.loaded]),
    );
  });

  test('loadProduct transitions to error on failure', () async {
    fakeRepository.result = Future.value(
      const Left(NetworkFailure(message: 'Connection lost')),
    );

    await provider.loadProduct(5);

    expect(provider.state, ProviderViewState.error);
    expect(provider.isLoading, isFalse);
    expect(provider.errorMessage, 'Connection lost');
  });
}
