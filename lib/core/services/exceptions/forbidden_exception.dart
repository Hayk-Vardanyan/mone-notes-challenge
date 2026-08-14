import 'api_exception.dart';

class ForbiddenException extends ApiException {
  ForbiddenException({
    required super.requestOptions,
    required super.message,
    super.stackTrace,
  });

  static const statusCode = 403;
}
