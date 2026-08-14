import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart' hide Router;
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get_it/get_it.dart';
import 'package:overlay_support/overlay_support.dart';

import 'core/navigation/app_navigator.dart';
import 'core/services/flavor_service.dart';
import 'extensions/context_extension.dart';
import 'injectable.dart';
import 'shared/features/connection_wrapper/view/connection_wrapper_page.dart';
import 'shared/wrappers/app_lifecycle_wrapper.dart';
import 'shared/wrappers/multi_wrapper.dart';
import 'themes/dark_theme.dart';
import 'themes/light_theme.dart';

class MyApp extends HookWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiWrapper(
      wrappers: const [AppLifecycleWrapper()],
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarBrightness: context.theme.brightness,
        ),
        child: OverlaySupport.global(
          child: DefaultTextHeightBehavior(
            textHeightBehavior: const TextHeightBehavior(
              leadingDistribution: TextLeadingDistribution.even,
            ),
            child: MaterialApp.router(
              supportedLocales: context.supportedLocales,
              locale: context.locale,
              localizationsDelegates: context.localizationDelegates,
              debugShowCheckedModeBanner: GetIt.I<FlavorService>().isDev,
              theme: lightTheme,
              darkTheme: darkTheme,
              routerConfig: getIt<AppNavigator>().config,
              builder: (context, child) {
                return ConnectionWrapperPage(child: child!);
              },
            ),
          ),
        ),
      ),
    );
  }
}
