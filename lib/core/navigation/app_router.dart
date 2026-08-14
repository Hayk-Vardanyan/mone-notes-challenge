import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../guards/auth_guard.dart';
import 'app_router.gr.dart';

export 'app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Page,Route')
class AppRouter extends RootStackRouter {
  @override
  final List<AutoRoute> routes = [
    AutoRoute(
      initial: true,
      path: '/',
      page: HomeRoute.page,
      guards: [const AuthGuard()],
    ),
    AutoRoute(path: '/search', page: SearchRoute.page),
    AutoRoute(path: '/notes/new', page: NoteEditorRoute.page),
    AutoRoute(path: '/notes/:noteId', page: NoteReadingRoute.page),
  ];
}

@RoutePage()
class EmptyPage extends StatelessWidget {
  const EmptyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(color: Theme.of(context).scaffoldBackgroundColor);
  }
}
