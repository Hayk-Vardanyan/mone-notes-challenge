import 'package:flutter/material.dart';

class ModalService {
  static Future<T?> showAppModal<T>(
    BuildContext context,
    WidgetBuilder builder, {
    bool isScrollControlled = true,
  }) {
    return showModalBottomSheet<T?>(
      context: context,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      isScrollControlled: isScrollControlled,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (context) {
        return builder(context);
      },
    );
  }
}
