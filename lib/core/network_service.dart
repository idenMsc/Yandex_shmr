import 'package:dio/dio.dart';
import 'network_client.dart';

class NetworkService {
  final NetworkClient _client;
  NetworkService(this._client);
  Dio get _dio => _client.dio;

  Future<T> get<T>(String path,
      {Map<String, dynamic>? query, Options? options}) async {
    try {
      final response =
          await _dio.get<T>(path, queryParameters: query, options: options);
      return response.data as T;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<T> post<T>(String path,
      {dynamic data, Map<String, dynamic>? query, Options? options}) async {
    try {
      final response = await _dio.post<T>(path,
          data: data, queryParameters: query, options: options);
      return response.data as T;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<T> put<T>(String path,
      {dynamic data, Map<String, dynamic>? query, Options? options}) async {
    try {
      final response = await _dio.put<T>(path,
          data: data, queryParameters: query, options: options);
      return response.data as T;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> delete(String path,
      {dynamic data, Map<String, dynamic>? query, Options? options}) async {
    try {
      await _dio.delete(path,
          data: data, queryParameters: query, options: options);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Exception _handleError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return Exception('Timeout error: ${e.message}');
      case DioExceptionType.badResponse:
        return Exception('HTTP error: ${e.response?.statusCode}');
      case DioExceptionType.cancel:
        return Exception('Request cancelled');
      case DioExceptionType.connectionError:
        return Exception('Connection error: ${e.message}');
      default:
        return Exception('Network error: ${e.message}');
    }
  }
}
