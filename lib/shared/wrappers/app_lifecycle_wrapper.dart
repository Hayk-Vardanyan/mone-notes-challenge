import 'package:flutter/widgets.dart';
import 'package:nested/nested.dart';

import '../../injectable.dart';
import '../stores/app_lifecycle/app_lifecycle_store.dart';

/// Funnels platform lifecycle events into [AppLifecycleStore] so any store can
/// react to foreground/background transitions without touching the widget tree.
class AppLifecycleWrapper extends SingleChildStatelessWidget {
  const AppLifecycleWrapper({super.key});

  @override
  Widget buildWithChild(BuildContext context, Widget? child) {
    return _AppLifecycleWrapper(child: child!);
  }
}

class _AppLifecycleWrapper extends StatefulWidget {
  const _AppLifecycleWrapper({required this.child});

  final Widget child;

  @override
  State<_AppLifecycleWrapper> createState() => _AppLifecycleWrapperState();
}

class _AppLifecycleWrapperState extends State<_AppLifecycleWrapper>
    with WidgetsBindingObserver {
  final _store = getIt<AppLifecycleStore>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    _store.onStateChanged(state);
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
