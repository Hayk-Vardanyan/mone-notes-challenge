import 'package:notes_app/core/services/exceptions/api_exception.dart';

typedef UUID = String;

typedef Token = String;

typedef Json = Map<String, dynamic>;

typedef CreatedAt = DateTime;
typedef UpdatedAt = DateTime;

typedef ApiErrorCallback = void Function(ApiException);
typedef ApiSuccessCallback = void Function(String);
