import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/app/navigation_key_manager.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/core/config/flavor_config.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/core/data/app_logger_impl.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/core/data/app_router_impl.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/core/data/local_storage_manager_impl.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/core/domain/app_logger.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/core/domain/app_router.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/core/domain/local_storage_manager.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/core/presentation/providers/theme_provider.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/core/services/network/api_service.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/core/services/network/mock_service.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/features/home/data/data_sources/home_remote_data_source.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/features/home/data/repositories/home_repository_impl.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/features/home/domain/repositories/home_repository.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/features/home/domain/usecases/get_categories_use_case.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/features/home/domain/usecases/get_products_by_category_use_case.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/features/home/domain/usecases/get_products_use_case.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/features/home/domain/usecases/search_products_use_case.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/features/home/presentation/state/home_provider.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/features/splash/presentation/state/splash_provider.dart';

final getIt = GetIt.instance;

Future<void> setupDependencies() async {
  final flavorConfig = FlavorConfig.instance;
  final bool useMock = flavorConfig.isMock;

  String resolvedBaseUrl;
  switch (flavorConfig.flavor) {
    case Flavor.mock:
      resolvedBaseUrl =
          dotenv.env[flavorConfig.baseUrlKey] ?? 'https://dummyjson.com/';
      break;
    case Flavor.dev:
      resolvedBaseUrl =
          dotenv.env[flavorConfig.baseUrlKey] ?? 'https://dummyjson.com/';
      break;
    case Flavor.uat:
      resolvedBaseUrl =
          dotenv.env[flavorConfig.baseUrlKey] ?? 'https://dummyjson.com/';
      break;
    case Flavor.prod:
      resolvedBaseUrl =
          dotenv.env[flavorConfig.baseUrlKey] ?? 'https://dummyjson.com/';
      break;
  }

  final dio = Dio(
    BaseOptions(
      baseUrl: resolvedBaseUrl,
      connectTimeout: const Duration(minutes: 30),
      receiveTimeout: const Duration(minutes: 30),
    ),
  );

  getIt.registerSingleton<FlutterSecureStorage>(const FlutterSecureStorage());
  getIt.registerSingleton<Logger>(Logger());

  getIt.registerSingleton(NavigationKeyManager());
  getIt.registerLazySingleton<AppLogger>(() => AppLoggerImpl(getIt<Logger>()));
  getIt.registerLazySingleton<LocalStorageManager>(
    () => LocalStorageManagerImpl(getIt<FlutterSecureStorage>()),
  );
  getIt.registerSingleton<AppRouter>(
    AppRouterImpl(getIt<NavigationKeyManager>()),
  );

  getIt.registerLazySingleton<ApiService>(
    () => useMock
        ? MockService()
        : ApiService(dio: dio, appLogger: getIt<AppLogger>()),
  );

  getIt.registerLazySingleton<HomeRemoteDataSource>(
    () => HomeRemoteDataSourceImpl(apiService: getIt<ApiService>()),
  );
  getIt.registerLazySingleton<HomeRepository>(
    () =>
        HomeRepositoryImpl(homeRemoteDataSource: getIt<HomeRemoteDataSource>()),
  );
  getIt.registerLazySingleton<GetProductsUseCase>(
    () => GetProductsUseCase(homeRepository: getIt<HomeRepository>()),
  );
  getIt.registerLazySingleton<SearchProductsUseCase>(
    () => SearchProductsUseCase(homeRepository: getIt<HomeRepository>()),
  );
  getIt.registerLazySingleton<GetProductsByCategoryUseCase>(
    () => GetProductsByCategoryUseCase(homeRepository: getIt<HomeRepository>()),
  );
  getIt.registerLazySingleton<GetCategoriesUseCase>(
    () => GetCategoriesUseCase(homeRepository: getIt<HomeRepository>()),
  );

  getIt.registerFactory(() => SplashProvider(router: getIt<AppRouter>()));
  getIt.registerFactory(
    () => HomeProvider(
      getProductsUseCase: getIt<GetProductsUseCase>(),
      searchProductsUseCase: getIt<SearchProductsUseCase>(),
      getProductsByCategoryUseCase: getIt<GetProductsByCategoryUseCase>(),
      getCategoriesUseCase: getIt<GetCategoriesUseCase>(),
    ),
  );

  getIt.registerFactory(() => ThemeProvider(getIt<LocalStorageManager>()));
}
