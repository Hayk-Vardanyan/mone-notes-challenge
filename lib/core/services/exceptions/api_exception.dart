import 'package:dio/dio.dart';

abstract class ApiException extends DioException {
  ApiException({
    required super.requestOptions,
    required this.message,
    super.stackTrace,
  });

  @override
  final String message;
}
