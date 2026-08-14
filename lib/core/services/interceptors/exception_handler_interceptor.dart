import 'package:dio/dio.dart';

import '../exceptions/api_exception.dart';
import '../exceptions/bad_request_exception.dart';
import '../exceptions/forbidden_exception.dart';
import '../exceptions/no_connection_exception.dart';
import '../exceptions/not_found_exception.dart';
import '../exceptions/server_unavailable_exception.dart';
import '../exceptions/unauthorized_exception.dart';

class ExceptionHandlerInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final ApiException apiException;

    if (err.type == DioExceptionType.cancel) {
      return;
    }

    if (err.type == DioExceptionType.connectionError) {
      handler.next(
        NoConnectionException(
          requestOptions: err.requestOptions,
          stackTrace: err.stackTrace,
        ),
      );

      return;
    }

    switch (err.response?.statusCode) {
      case UnauthorizedException.statusCode:
        apiException = UnauthorizedException(
          requestOptions: err.requestOptions,
        );
      case ForbiddenException.statusCode:
        apiException = ForbiddenException(
          message: 'error.forbidden',
          requestOptions: err.requestOptions,
        );
      case NotFoundException.statusCode:
        apiException = NotFoundException(
          message: 'error.somethingWentWrong',
          requestOptions: err.requestOptions,
        );
      case BadRequestException.statusCode:
        apiException = BadRequestException(
          message: err.response?.data?['message'] is List
              ? (err.response?.data?['message'] as List).join(',')
              : err.response?.data?['message'] ?? 'error.somethingWentWrong',
          requestOptions: err.requestOptions,
        );
      default:
        apiException = ServerUnavailableException(
          message: 'error.somethingWentWrong',
          requestOptions: err.requestOptions,
        );
    }

    handler.next(apiException);
  }
}
