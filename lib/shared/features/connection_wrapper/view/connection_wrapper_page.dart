import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

import '../../../../extensions/extensions.dart';
import '../../../../injectable.dart';
import '../mobx/connection_wrapper_state.dart';

class ConnectionWrapperPage extends StatelessWidget {
  const ConnectionWrapperPage({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Provider<ConnectionWrapperState>(
      create: (_) => getIt<ConnectionWrapperState>(),
      dispose: (_, state) => state.dispose(),
      child: _ConnectionWrapperContent(child: child),
    );
  }
}

class _ConnectionWrapperContent extends StatelessWidget {
  const _ConnectionWrapperContent({
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final state = context.read<ConnectionWrapperState>();
    return Observer(
      builder: (_) {
        return state.hasConnection ? child : const _NoConnectionWidget();
      },
    );
  }
}

class _NoConnectionWidget extends StatelessWidget {
  const _NoConnectionWidget();

  @override
  Widget build(BuildContext context) {
    final state = context.read<ConnectionWrapperState>();

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.wifi_off, size: 48),
            const Gap(16),
            Text(
              'error.noConnectionTitle'.tr(),
              style: context.theme.titleMedium,
            ),
            const Gap(8),
            Text(
              'error.noConnection'.tr(),
              style: context.theme.bodyMedium,
            ),
            const Gap(24),
            ElevatedButton(
              onPressed: state.onSettingsTap,
              child: Text('keywords.openSettings'.tr()),
            ),
          ],
        ),
      ),
    );
  }
}
