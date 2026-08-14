import 'package:injectable/injectable.dart';

import '../logging/app_logger.dart';

/// Vendor-agnostic analytics contract. Register a concrete implementation
/// with `@LazySingleton(as: AnalyticsService)` to replace the default no-op.
abstract interface class AnalyticsService {
  Future<void> init();

  Future<void> identify(String userId, {Map<String, dynamic>? traits});

  Future<void> track(String event, {Map<String, dynamic>? properties});

  Future<void> reset();
}

@LazySingleton(as: AnalyticsService)
class NoopAnalyticsService implements AnalyticsService {
  @override
  Future<void> init() async {
    AppLogger.debugLog('analytics: init');
  }

  @override
  Future<void> identify(String userId, {Map<String, dynamic>? traits}) async {
    AppLogger.debugLog('analytics: identify $userId $traits');
  }

  @override
  Future<void> track(String event, {Map<String, dynamic>? properties}) async {
    AppLogger.debugLog('analytics: track $event $properties');
  }

  @override
  Future<void> reset() async {
    AppLogger.debugLog('analytics: reset');
  }
}
