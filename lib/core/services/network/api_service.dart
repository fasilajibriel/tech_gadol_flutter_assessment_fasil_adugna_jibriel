import 'package:dio/dio.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/core/domain/app_logger.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/core/error/failure.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/core/models/api_response.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/network/interceptors/logging_interceptor.dart';

class ApiService {
  final Dio dio;
  final AppLogger appLogger;

  ApiService({required this.dio, required this.appLogger}) {
    addInterceptors();
  }

  void addInterceptors() {
    dio.interceptors.addAll([LoggingInterceptor(appLogger: appLogger)]);
  }

  Future<ApiResponse<T>> get<T>({
    required String endpoint,
    Map<String, dynamic>? queryParams,
  }) async {
    try {
      final response = await dio.get(endpoint, queryParameters: queryParams);
      return _parseResponse<T>(response);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<ApiResponse<T>> post<T>({
    required String endpoint,
    dynamic data,
  }) async {
    try {
      final response = await dio.post(endpoint, data: data);
      return _parseResponse<T>(response);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<ApiResponse<T>> put<T>({
    required String endpoint,
    dynamic data,
  }) async {
    try {
      final response = await dio.put(endpoint, data: data);
      return _parseResponse<T>(response);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<ApiResponse<T>> delete<T>({required String endpoint}) async {
    try {
      final response = await dio.delete(endpoint);
      return _parseResponse<T>(response);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  ApiResponse<T> _parseResponse<T>(Response response) {
    return ApiResponse<T>(
      statusCode: response.statusCode ?? 500,
      data: response.data as T,
      message: response.statusMessage,
    );
  }

  Failure _handleDioError(DioException error) {
    final response = error.response;
    if (response != null) {
      final statusCode = response.statusCode ?? 500;
      return ApiFailure(
        message:
            _resolveResponseMessage(response.data) ??
            response.statusMessage ??
            'Request failed',
        statusCode: statusCode,
      );
    }

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return const NetworkFailure(message: 'Connection timed out.');
      case DioExceptionType.sendTimeout:
        return const NetworkFailure(message: 'Request send timed out.');
      case DioExceptionType.receiveTimeout:
        return const NetworkFailure(message: 'Response timed out.');
      case DioExceptionType.badCertificate:
        return const NetworkFailure(message: 'Bad SSL certificate.');
      case DioExceptionType.connectionError:
        return const NetworkFailure(message: 'No internet connection.');
      case DioExceptionType.cancel:
        return const UnknownFailure(message: 'Request was cancelled.');
      case DioExceptionType.badResponse:
        return const ApiFailure(
          message: 'Unexpected server response.',
          statusCode: 500,
        );
      case DioExceptionType.unknown:
        return UnknownFailure(
          message: error.message ?? 'Unexpected network error.',
        );
    }
  }

  String? _resolveResponseMessage(dynamic data) {
    if (data is Map<String, dynamic>) {
      final message = data['message'] ?? data['error'];
      if (message is String && message.isNotEmpty) {
        return message;
      }
    } else if (data is String && data.isNotEmpty) {
      return data;
    }
    return null;
  }
}
