import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import 'flavor_service.dart';
import 'interceptors/api_interceptor.dart';
import 'interceptors/auth_interceptor.dart';
import 'interceptors/exception_handler_interceptor.dart';
import 'session/session_service.dart';

@module
abstract class RegisterDio {
  @lazySingleton
  Dio dio(FlavorService config, SessionService sessionService) =>
      Dio(BaseOptions(baseUrl: config.config.apiUrl))
        ..transformer = BackgroundTransformer()
        ..interceptors.addAll([
          ApiInterceptor(),
          AuthInterceptor(sessionService),
          if (kDebugMode) PrettyDioLogger(requestHeader: true),
          ExceptionHandlerInterceptor(),
        ])
        ..options.headers[HttpHeaders.contentTypeHeader] = 'application/json'
        ..options.headers['x-language-code'] = Platform.localeName;
}
