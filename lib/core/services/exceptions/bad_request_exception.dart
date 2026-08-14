import 'api_exception.dart';

class BadRequestException extends ApiException {
  BadRequestException({
    required super.requestOptions,
    required super.message,
    super.stackTrace,
  });

  static const statusCode = 400;
}
