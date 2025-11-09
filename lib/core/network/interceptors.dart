// ignore_for_file: unused_element, body_might_complete_normally_nullable, avoid_print

import 'dart:collection';

import 'package:dio/dio.dart';

class RefreshTokenInterceptor extends Interceptor {
  final Dio dio;
  bool _isRefreshing = false;
  final Queue<_RetryRequest> _queue = Queue();
  RefreshTokenInterceptor(this.dio);

  Future<Response> _retry(RequestOptions requestOptions) async {
    final options = Options(
      method: requestOptions.method,
      headers: requestOptions.headers,
    );

    return dio.request<dynamic>(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: options,
    );
  }

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    String? token;
    try {
      token = await getToken();
    } catch (e) {
      print(e);
    }
    try {
      print('options.headers: $token');
      if (token != null) {
        options.headers['Authorization'] = token;
      }
      handler.next(options);
    } catch (e) {
      rethrow;
    }
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    print('Error: ${err.message}');
    if (err.response?.statusCode == 401) {
      final options = err.requestOptions;
      if (_isRefreshing) {
        _queue.add(_RetryRequest(options: options, handler: handler));
        return;
      }
      _isRefreshing = true;
    }
    return handler.next(err);
  }

  Future<String?> getToken() async {}
}

class _RetryRequest {
  final RequestOptions options;
  final ErrorInterceptorHandler handler;

  _RetryRequest({required this.options, required this.handler});
}
