import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/core/domain/app_logger.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/core/models/api_response.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/di/injector.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/core/services/network/api_service.dart';

class MockService extends ApiService {
  MockService() : super(dio: Dio(), appLogger: getIt<AppLogger>());

  String _path(String endpoint) {
    final clean = endpoint.replaceFirst(RegExp(r'^/'), '').replaceAll('/', '_');
    return 'assets/data/$clean.json';
  }

  Future<dynamic> _load(String path) async {
    final String jsonString = await rootBundle.loadString(path);
    return json.decode(jsonString);
  }

  @override
  Future<ApiResponse<T>> get<T>({
    required String endpoint,
    Map<String, dynamic>? queryParams,
  }) async {
    final data = await _load(_path(endpoint));
    await Future.delayed(const Duration(seconds: 2));
    return ApiResponse<T>(statusCode: 200, data: data as T, message: null);
  }

  @override
  Future<ApiResponse<T>> post<T>({required String endpoint, dynamic data}) async {
    final mockData = await _load(_path(endpoint));
    await Future.delayed(const Duration(seconds: 2));
    return ApiResponse<T>(statusCode: 200, data: mockData as T, message: null);
  }

  @override
  Future<ApiResponse<T>> put<T>({required String endpoint, dynamic data}) async {
    final mockData = await _load(_path(endpoint));
    await Future.delayed(const Duration(seconds: 2));
    return ApiResponse<T>(statusCode: 200, data: mockData as T, message: null);
  }

  @override
  Future<ApiResponse<T>> delete<T>({required String endpoint}) async {
    await Future.delayed(const Duration(seconds: 2));
    return ApiResponse<T>(statusCode: 200, data: null, message: null);
  }
}
