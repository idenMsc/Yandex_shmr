import 'package:dio/dio.dart';
import 'network_retry_interceptor.dart';
import 'network_config.dart';
import 'network_deserialize_interceptor.dart';

class NetworkClient {
  late final Dio _dio;

  NetworkClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: NetworkConfig.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );
    _setupInterceptors();
  }

  Dio get dio => _dio;

  void _setupInterceptors() {
    _dio.interceptors.add(NetworkRetryInterceptor());
    _dio.interceptors.add(NetworkDeserializeInterceptor());
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          options.headers['Authorization'] = 'Bearer ${NetworkConfig.token}';
          handler.next(options);
        },
        onResponse: (response, handler) {
          handler.next(response);
        },
        onError: (error, handler) {
          handler.next(error);
        },
      ),
    );
  }
}
