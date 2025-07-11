import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:worker_manager/worker_manager.dart';

class NetworkDeserializeInterceptor extends Interceptor {
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    if (response.data != null &&
        response.headers['content-type']
                ?.any((h) => h.contains('application/json')) ==
            true) {
      try {
        final parsed = await workerManager
            .execute(() => _parseJsonInIsolate(response.data));
        response.data = parsed;
      } catch (e) {
        // Если что-то пошло не так — оставляем оригинал
      }
    }
    handler.next(response);
  }
}

dynamic _parseJsonInIsolate(dynamic data) {
  if (data is Map || data is List) return data;
  if (data is String) {
    try {
      return jsonDecode(data);
    } catch (_) {}
  }
  return data;
}
