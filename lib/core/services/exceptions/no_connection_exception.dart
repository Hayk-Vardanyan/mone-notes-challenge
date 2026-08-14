import 'api_exception.dart';

class NoConnectionException extends ApiException {
  NoConnectionException({
    required super.requestOptions,
    super.stackTrace,
  }) : super(message: 'error.noConnection');
}
