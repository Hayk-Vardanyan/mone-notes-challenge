import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide Router;
import 'package:injectable/injectable.dart';
import 'package:open_settings_plus/core/open_settings_plus.dart';
import 'package:overlay_support/overlay_support.dart';

import '../../extensions/context_extension.dart';
import 'app_router.dart';

export 'app_router.dart';

final _router = AppRouter();

@singleton
class AppNavigator {
  RouterConfig<UrlState> get config => _router.config();

  BuildContext? get context => _router.navigatorKey.currentContext;

  String get currentMobilePath => _router.currentPath;

  Future<bool> pop<T extends Object?>({T? result}) {
    return _router.maybePop(result);
  }

  void popUntilRoot() {
    return _router.popUntilRoot();
  }

  Future<void> popUntilRouteWithName(String routeName) async {
    _router.popUntilRouteWithName(routeName);
  }

  Future<T?> push<T extends Object?>(
    PageRouteInfo route, {
    OnNavigationFailure? onFailure,
  }) {
    return _router.push(route, onFailure: onFailure);
  }

  Future<void> navigateNamed<T extends Object?>(
    String path, {
    OnNavigationFailure? onFailure,
  }) {
    return _router.navigateNamed(path, onFailure: onFailure);
  }

  Future<void> navigate<T extends Object?>(
    PageRouteInfo route, {
    OnNavigationFailure? onFailure,
  }) {
    return _router.navigate(route, onFailure: onFailure);
  }

  Future<void> pushAndPopAll(
    PageRouteInfo route, {
    OnNavigationFailure? onFailure,
  }) {
    return _router.replaceAll([route], onFailure: onFailure);
  }

  Future<T?> replace<T extends Object?>(
    PageRouteInfo route, {
    OnNavigationFailure? onFailure,
  }) {
    return _router.replace(route, onFailure: onFailure);
  }

  Future<void> replaceAll<T extends Object?>(
    List<PageRouteInfo> routes, {
    OnNavigationFailure? onFailure,
  }) {
    return _router.replaceAll(routes, onFailure: onFailure);
  }

  bool canPop({
    bool ignoreChildRoutes = false,
    bool ignoreParentRoutes = false,
    bool ignorePagelessRoutes = false,
  }) {
    return _router.canPop();
  }

  Future<T?> showModal<T>({
    required WidgetBuilder builder,
    Color? backgroundColor,
    bool isScrollControlled = true,
    bool isDismissible = true,
    bool enableDrag = true,
    bool useRootNavigator = true,
    bool useSafeArea = true,
  }) {
    if (context == null) {
      return Future.error(Exception('Context is null'));
    }

    return showModalBottomSheet<T?>(
      context: context!,
      isScrollControlled: isScrollControlled,
      useRootNavigator: useRootNavigator,
      useSafeArea: useSafeArea,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      constraints: BoxConstraints(
        maxHeight: context!.height - context!.topPadding - kToolbarHeight,
      ),
      backgroundColor:
          backgroundColor ?? context!.theme.scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      clipBehavior: Clip.antiAlias,
      builder: builder,
      sheetAnimationStyle: AnimationStyle(
        curve: Curves.bounceIn,
        reverseCurve: Curves.bounceOut,
        duration: Durations.medium3,
        reverseDuration: Durations.medium1,
      ),
    );
  }

  Future<void> showAppDialog({
    required String title,
    required String content,
    String? buttonText,
    VoidCallback? onButtonPressed,
    String? closeButtonText,
    bool barrierDismissible = true,
    bool useRootNavigator = true,
  }) async {
    final context = this.context;
    if (context == null) {
      throw Exception('Context is null');
    }

    return showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      useRootNavigator: useRootNavigator,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            if (closeButtonText != null)
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: Text(closeButtonText),
              ),
            if (buttonText != null)
              TextButton(
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                  onButtonPressed?.call();
                },
                child: Text(buttonText),
              ),
          ],
        );
      },
    );
  }

  void showErrorMessage({required String title, required String message}) {
    _showMessage(title: title, message: message, isError: true);
  }

  void showSuccessMessage({required String title, required String message}) {
    _showMessage(title: title, message: message, isError: false);
  }

  void _showMessage({
    required String title,
    required String message,
    required bool isError,
  }) {
    final context = this.context;
    if (context == null) {
      throw Exception('Context is null');
    }

    final theme = context.theme;

    showScaffoldMessage(
      Material(
        color: isError ? theme.colorScheme.error : theme.colorScheme.primary,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.titleMedium.copyWith(
                  color: isError
                      ? theme.colorScheme.onError
                      : theme.colorScheme.onPrimary,
                ),
              ),
              Text(
                message,
                style: theme.bodyMedium.copyWith(
                  color: isError
                      ? theme.colorScheme.onError
                      : theme.colorScheme.onPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> openPhoneSettings() {
    return switch (OpenSettingsPlus.shared) {
      final OpenSettingsPlusAndroid settings => settings.appSettings(),
      final OpenSettingsPlusIOS settings => settings.appSettings(),
      _ => throw Exception('Platform not supported'),
    };
  }

  void showFullScreenLoading() {
    final context = _router.navigatorKey.currentContext;
    if (context == null) {
      throw Exception('Context is null');
    }
    unawaited(
      showDialog(
        context: context,
        barrierDismissible: false,
        useSafeArea: false,
        builder: (context) {
          return const CupertinoActivityIndicator();
        },
      ),
    );
  }

  Future<void> hideFullScreenLoading() {
    return pop();
  }

  OverlaySupportEntry showScaffoldMessage(Widget content) {
    final context = this.context;
    if (context == null) {
      throw Exception('Context is required');
    }
    return showSimpleNotification(
      content,
      position: NotificationPosition.bottom,
      background: Colors.transparent,
      duration: const Duration(seconds: 3),
      slideDismissDirection: DismissDirection.down,
      elevation: 0,
    );
  }
}
