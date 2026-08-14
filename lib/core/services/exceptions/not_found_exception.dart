import 'api_exception.dart';

class NotFoundException extends ApiException {
  NotFoundException({
    required super.requestOptions,
    required super.message,
    super.stackTrace,
  });

  static const statusCode = 404;
}
