import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app.dart';
import 'core/constants/flavor_type.dart';
import 'core/constants/supported_locals.dart';
import 'core/services/analytics/analytics_service.dart';
import 'core/services/get_it.dart';
import 'core/services/logging/app_logger.dart';
import 'injectable.dart';

void main() {
  runZonedGuarded(
    () async {
      await _bootstrap(env: FlavorType.DEVELOPMENT);
    },
    (error, stack) {
      AppLogger.error('Zoned error', error: error, stackTrace: stack);
    },
  );
}

Future<void> _bootstrap({required FlavorType env}) async {
  WidgetsFlutterBinding.ensureInitialized();

  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    AppLogger.error(
      'FlutterError: ${details.exception}',
      error: details.exception,
      stackTrace: details.stack,
    );
  };

  await SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await EasyLocalization.ensureInitialized();

  registerGetIt(env);

  await getIt<AnalyticsService>().init();

  AppLogger.info('APP STARTED in ${kReleaseMode ? 'RELEASE' : 'DEBUG'}');

  _runApp();
}

void _runApp() {
  runApp(
    EasyLocalization(
      supportedLocales: SupportedLocals.values.map((e) => e.getLocal).toList(),
      startLocale: SupportedLocals.EN.getLocal,
      fallbackLocale: SupportedLocals.EN.getLocal,
      path: 'assets/translations',
      child: const MyApp(),
    ),
  );
}
