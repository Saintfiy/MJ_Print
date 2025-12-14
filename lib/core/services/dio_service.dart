import 'package:dio/dio.dart';
import 'package:mj_print/core/models/simple_response_model.dart';

class DioService {
  late Dio _dio;
  static const String baseUrl = 'https://jsonplaceholder.typicode.com';

  DioService() {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
      },
    ));

    // Add interceptors
    _dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
    ));
  }

  Future<SimpleResponseModel> get(String endpoint) async {
    try {
      final response = await _dio.get(endpoint);
      
      return SimpleResponseModel(
        success: true,
        message: 'Data fetched successfully',
        data: response.data,
      );
    } on DioException catch (e) {
      return SimpleResponseModel(
        success: false,
        message: _handleDioError(e),
      );
    } catch (e) {
      return SimpleResponseModel(
        success: false,
        message: 'Error: $e',
      );
    }
  }

  Future<SimpleResponseModel> post(
    String endpoint, 
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await _dio.post(endpoint, data: data);
      
      return SimpleResponseModel(
        success: true,
        message: 'Data posted successfully',
        data: response.data,
      );
    } on DioException catch (e) {
      return SimpleResponseModel(
        success: false,
        message: _handleDioError(e),
      );
    } catch (e) {
      return SimpleResponseModel(
        success: false,
        message: 'Error: $e',
      );
    }
  }

  Future<SimpleResponseModel> put(
    String endpoint, 
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await _dio.put(endpoint, data: data);
      
      return SimpleResponseModel(
        success: true,
        message: 'Data updated successfully',
        data: response.data,
      );
    } on DioException catch (e) {
      return SimpleResponseModel(
        success: false,
        message: _handleDioError(e),
      );
    } catch (e) {
      return SimpleResponseModel(
        success: false,
        message: 'Error: $e',
      );
    }
  }

  Future<SimpleResponseModel> delete(String endpoint) async {
    try {
      final response = await _dio.delete(endpoint);
      
      return SimpleResponseModel(
        success: true,
        message: 'Data deleted successfully',
        data: response.data,
      );
    } on DioException catch (e) {
      return SimpleResponseModel(
        success: false,
        message: _handleDioError(e),
      );
    } catch (e) {
      return SimpleResponseModel(
        success: false,
        message: 'Error: $e',
      );
    }
  }

  String _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return 'Connection timeout';
      case DioExceptionType.sendTimeout:
        return 'Send timeout';
      case DioExceptionType.receiveTimeout:
        return 'Receive timeout';
      case DioExceptionType.badCertificate:
        return 'Bad certificate';
      case DioExceptionType.badResponse:
        return 'Bad response: ${e.response?.statusCode}';
      case DioExceptionType.cancel:
        return 'Request cancelled';
      case DioExceptionType.connectionError:
        return 'Connection error';
      case DioExceptionType.unknown:
        return 'Unknown error: ${e.message}';
    }
  }
}