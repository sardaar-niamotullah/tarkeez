import 'package:tarkeez/core/shared_files/snackbar/snack_bar_tile_wrapper.dart';
import 'package:flutter/material.dart';

void snackBarOverlayInitializer(
  BuildContext context, {
  String? title,
  required String message,
  required String iconPath,
  required Color backgroundColor,
  required Color backgroundColorBright,
  required Color textColor,
  required Color iconColor,
}) {
  final scheme = Theme.of(context).colorScheme;
  final topPadding = MediaQueryData.fromView(View.of(context)).padding.top;

  late OverlayEntry entry;

  entry = OverlayEntry(
    builder: (_) => SnackBarTileWrapper(
      title: title,
      message: message,
      iconPath: iconPath,
      iconColor: iconColor,
      backgroundColor: backgroundColor,
      backgroundColorBright: backgroundColorBright,
      textColor: textColor,
      scheme: scheme,
      topPadding: topPadding,

      // ── Remove entry from overlay once animation completes ─────────────
      onDismiss: () => entry.remove(),
    ),
  );

  Overlay.of(context).insert(entry);
}
