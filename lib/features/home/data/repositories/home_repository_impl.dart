import 'package:dartz/dartz.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/core/error/failure.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/features/home/data/data_sources/home_remote_data_source.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/features/home/data/models/categories_respones_model/categories_respones_model.dart';
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

  @override
  Future<Either<Failure, ProductsResponseModel>> searchProducts({
    required String query,
    required int limit,
    required int skip,
  }) async {
    try {
      final products = await _homeRemoteDataSource.searchProducts(
        query: query,
        limit: limit,
        skip: skip,
      );
      return Right(products);
    } on Failure catch (failure) {
      return Left(failure);
    } catch (error) {
      return Left(
        UnknownFailure(message: 'Failed to search products by text: $error'),
      );
    }
  }

  @override
  Future<Either<Failure, ProductsResponseModel>> getProductsByCategory({
    required String category,
    required int limit,
    required int skip,
  }) async {
    try {
      final products = await _homeRemoteDataSource.getProductsByCategory(
        category: category,
        limit: limit,
        skip: skip,
      );
      return Right(products);
    } on Failure catch (failure) {
      return Left(failure);
    } catch (error) {
      return Left(
        UnknownFailure(message: 'Failed to fetch category products: $error'),
      );
    }
  }

  @override
  Future<Either<Failure, List<CategoriesResponesModel>>> getCategories() async {
    try {
      final categories = await _homeRemoteDataSource.getCategories();
      return Right(categories);
    } on Failure catch (failure) {
      return Left(failure);
    } catch (error) {
      return Left(
        UnknownFailure(message: 'Failed to fetch categories: $error'),
      );
    }
  }
}
