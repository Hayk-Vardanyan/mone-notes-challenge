import 'package:flutter/material.dart';

import '../../../core/navigation/app_navigator.dart';
import '../../../extensions/extensions.dart';
import '../../../injectable.dart';
import '../buttons/app_back_button.dart';

class AppTopBar extends StatelessWidget implements PreferredSizeWidget {
  const AppTopBar({
    super.key,
    this.title,
    this.centerTitle = false,
    this.forceNoneBack = false,
    this.onBackPressed,
    this.bottom,
    this.leading,
    this.actions,
    this.titleTextStyle,
    this.backgroundColor,
  });

  final bool? centerTitle;
  final bool forceNoneBack;
  final String? title;
  final TextStyle? titleTextStyle;
  final Color? backgroundColor;
  final VoidCallback? onBackPressed;
  final Widget? bottom;
  final Widget? leading;
  final List<Widget>? actions;

  @override
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight + (bottom == null ? 0 : 12));

  @override
  Widget build(BuildContext context) {
    final canPop = getIt<AppNavigator>().canPop();

    return AppBar(
      elevation: 0,
      backgroundColor: backgroundColor ?? context.theme.scaffoldBackgroundColor,
      leading:
          leading?.paddingOnly(left: 20) ??
          (forceNoneBack || !canPop ? null : const AppBackButton()),
      titleSpacing: canPop ? 0 : 16,
      centerTitle: centerTitle,
      title: title == null
          ? null
          : Text(
              title!,
              style: titleTextStyle ??
                  context.theme.titleMedium.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                  ),
            ),
      actions: actions,
      bottom: bottom == null
          ? null
          : PreferredSize(
              preferredSize: const Size.fromHeight(4),
              child: Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 4),
                child: bottom!,
              ),
            ),
    );
  }
}
