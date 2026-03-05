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
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/features/splash/presentation/state/splash_provider.dart';

final getIt = GetIt.instance;

Future<void> setupDependencies() async {
  final flavorConfig = FlavorConfig.instance;
  final bool useMock = flavorConfig.isMock;

  String resolvedBaseUrl;
  switch (flavorConfig.flavor) {
    case Flavor.mock:
      resolvedBaseUrl = dotenv.env[flavorConfig.baseUrlKey] ?? 'https://dummyjson.com/';
      break;
    case Flavor.dev:
      resolvedBaseUrl = dotenv.env[flavorConfig.baseUrlKey] ?? 'https://dummyjson.com/';
      break;
    case Flavor.uat:
      resolvedBaseUrl = dotenv.env[flavorConfig.baseUrlKey] ?? 'https://dummyjson.com/';
      break;
    case Flavor.prod:
      resolvedBaseUrl = dotenv.env[flavorConfig.baseUrlKey] ?? 'https://dummyjson.com/';
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
  getIt.registerLazySingleton<LocalStorageManager>(() => LocalStorageManagerImpl(getIt<FlutterSecureStorage>()));
  getIt.registerSingleton<AppRouter>(AppRouterImpl(getIt<NavigationKeyManager>()));

  getIt.registerLazySingleton<ApiService>(
    () => useMock ? MockService() : ApiService(dio: dio, appLogger: getIt<AppLogger>()),
  );

  getIt.registerFactory(() => SplashProvider(router: getIt<AppRouter>()));

  getIt.registerFactory(() => ThemeProvider(getIt<LocalStorageManager>()));
}
