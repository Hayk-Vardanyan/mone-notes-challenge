import 'api_exception.dart';

class UnProcessableEntityException extends ApiException {
  UnProcessableEntityException({
    required super.requestOptions,
    required super.message,
    super.stackTrace,
  });

  static const statusCode = 422;
}
