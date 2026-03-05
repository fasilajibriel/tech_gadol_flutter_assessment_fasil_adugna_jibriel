import 'package:dartz/dartz.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/core/error/failure.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/features/home/data/data_sources/home_remote_data_source.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/features/home/data/models/products_response_model/products_response_model.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/features/home/domain/repositories/home_repository.dart';

class HomeRepositoryImpl implements HomeRepository {
  HomeRepositoryImpl({required HomeRemoteDataSource homeRemoteDataSource})
    : _homeRemoteDataSource = homeRemoteDataSource;

  final HomeRemoteDataSource _homeRemoteDataSource;

  @override
  Future<Either<Failure, ProductsResponseModel>> getProducts({
    required int limit,
    required int skip,
  }) async {
    try {
      final products = await _homeRemoteDataSource.getProducts(
        limit: limit,
        skip: skip,
      );
      return Right(products);
    } on Failure catch (failure) {
      return Left(failure);
    } catch (error) {
      return Left(UnknownFailure(message: 'Failed to fetch products: $error'));
    }
  }
}
