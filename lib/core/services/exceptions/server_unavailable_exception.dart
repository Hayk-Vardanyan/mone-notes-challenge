import 'api_exception.dart';

class ServerUnavailableException extends ApiException {
  ServerUnavailableException({
    required super.requestOptions,
    required super.message,
    super.stackTrace,
  });
}
