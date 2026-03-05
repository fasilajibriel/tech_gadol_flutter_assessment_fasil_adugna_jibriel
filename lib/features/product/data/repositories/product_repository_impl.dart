import 'package:dartz/dartz.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/core/error/failure.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/features/home/data/models/products_response_model/product.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/features/product/data/data_sources/product_remote_data_source.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/features/product/domain/repositories/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  ProductRepositoryImpl({required ProductRemoteDataSource remoteDataSource})
    : _remoteDataSource = remoteDataSource;

  final ProductRemoteDataSource _remoteDataSource;

  @override
  Future<Either<Failure, Product>> getProductById({required int id}) async {
    try {
      final product = await _remoteDataSource.getProductById(id: id);
      return Right(product);
    } on Failure catch (failure) {
      return Left(failure);
    } catch (error) {
      return Left(
        UnknownFailure(message: 'Failed to fetch product details: $error'),
      );
    }
  }
}
