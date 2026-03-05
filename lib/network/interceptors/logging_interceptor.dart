import 'package:dio/dio.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/core/domain/app_logger.dart';

class LoggingInterceptor extends Interceptor {
  final AppLogger appLogger;

  LoggingInterceptor({required this.appLogger});

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    appLogger.debug(
      'Request: ${options.method} ${options.uri}\nHeaders: ${options.headers}\nData: ${options.data}',
      className: 'LoggingInterceptor',
      methodName: 'onRequest',
    );
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    appLogger.info(
      'Response: ${response.statusCode} ${response.requestOptions.uri}\nData: ${response.data}',
      className: 'LoggingInterceptor',
      methodName: 'onResponse',
    );
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    appLogger.error(
      'Error: ${err.response?.data} (${err.response?.statusCode})',
      className: 'LoggingInterceptor',
      methodName: 'onError',
      error: err,
      stackTrace: err.stackTrace,
    );
    handler.next(err);
  }
}
