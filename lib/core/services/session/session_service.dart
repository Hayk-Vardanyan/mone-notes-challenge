import 'package:injectable/injectable.dart';

import '../../constants/typedef.dart';
import '../../utils/storage_utils.dart';

/// Seam between the networking layer and whatever authentication feature the
/// app ends up with. [AuthInterceptor] only knows about this contract, so no
/// interceptor has to import a store, a route or a repository.
abstract interface class SessionService {
  Future<Token?> readAccessToken();

  /// Invoked when the backend rejects the current session (HTTP 401).
  Future<void> onSessionExpired();
}

@LazySingleton(as: SessionService)
class StorageSessionService implements SessionService {
  @override
  Future<Token?> readAccessToken() => StorageUtils.getAccessToken();

  @override
  Future<void> onSessionExpired() => StorageUtils.removeAccessToken();
}
