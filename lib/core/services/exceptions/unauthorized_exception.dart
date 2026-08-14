import 'api_exception.dart';

class UnauthorizedException extends ApiException {
  UnauthorizedException({
    required super.requestOptions,
    super.stackTrace,
  }) : super(message: 'error.unauthorized');

  static const statusCode = 401;
}
