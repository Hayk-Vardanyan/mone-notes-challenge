import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';

import '../session/session_service.dart';

class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._sessionService);

  final SessionService _sessionService;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _sessionService.readAccessToken();

    options.headers[HttpHeaders.contentTypeHeader] = 'application/json';

    if (options.data is FormData) {
      options.headers[HttpHeaders.contentTypeHeader] = 'multipart/form-data';
    }

    if (token?.isNotEmpty == true) {
      options.headers
          .putIfAbsent(HttpHeaders.authorizationHeader, () => 'bearer $token');
    }

    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      unawaited(_sessionService.onSessionExpired());
    }
    return handler.next(err);
  }
}
