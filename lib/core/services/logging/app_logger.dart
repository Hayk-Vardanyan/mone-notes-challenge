import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';

enum LogLevel { debug, info, warning, error }

/// Thin logging facade so call sites never talk to `print`/`debugPrint`
/// directly. Swap the sink here to plug in Crashlytics, Sentry, etc.
class AppLogger {
  AppLogger._();

  static const _name = 'app';

  static void debugLog(Object? message) => _log(LogLevel.debug, message);

  static void info(Object? message) => _log(LogLevel.info, message);

  static void warning(Object? message) => _log(LogLevel.warning, message);

  static void error(
    Object? message, {
    Object? error,
    StackTrace? stackTrace,
  }) {
    _log(LogLevel.error, message, error: error, stackTrace: stackTrace);
  }

  static void _log(
    LogLevel level,
    Object? message, {
    Object? error,
    StackTrace? stackTrace,
  }) {
    if (!kDebugMode && level == LogLevel.debug) {
      return;
    }

    developer.log(
      '$message',
      name: '$_name.${level.name}',
      level: switch (level) {
        LogLevel.debug => 500,
        LogLevel.info => 800,
        LogLevel.warning => 900,
        LogLevel.error => 1000,
      },
      error: error,
      stackTrace: stackTrace,
    );
  }
}
