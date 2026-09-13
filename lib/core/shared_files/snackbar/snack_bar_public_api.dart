import 'package:tarkeez/core/shared_files/snackbar/snack_bar_overlay_initializer.dart';
import 'package:flutter/material.dart';
import 'package:tarkeez/core/constants/svg_paths.dart';
import 'package:tarkeez/core/theme/theme.dart';

// ──────────────────────────────────────────────
// Public API
// ──────────────────────────────────────────────
void showSuccessSnackBar(BuildContext context, {required String message}) {
  snackBarOverlayInitializer(
    context,
    title: 'Success',
    message: message,
    iconPath: SvgPaths.doneBold,
    backgroundColor: Theme.of(context).colorScheme.primary,
    backgroundColorBright: Theme.of(context).colorScheme.primaryContainer,
    textColor: AppTheme.white,
    iconColor: AppTheme.white,
  );
}

void showWarningSnackBar(BuildContext context, {required String message}) {
  snackBarOverlayInitializer(
    context,
    title: 'Warning',
    message: message,
    iconPath: SvgPaths.exclamation,
    backgroundColor: Theme.of(context).colorScheme.secondary,
    backgroundColorBright: Theme.of(context).colorScheme.secondaryContainer,
    textColor: AppTheme.black,
    iconColor: AppTheme.black,
  );
}

void showErrorSnackBar(BuildContext context, {required String message}) {
  snackBarOverlayInitializer(
    context,
    title: 'Error',
    message: message,
    iconPath: SvgPaths.exclamation,
    backgroundColor: AppTheme.error,
    backgroundColorBright: AppTheme.errorBright,
    textColor: AppTheme.white,
    iconColor: AppTheme.white,
  );
}

void showInfoSnackBar(
  BuildContext context, {
  required String iconPath,
  required String message,
  Color? iconColor,
}) {
  snackBarOverlayInitializer(
    context,
    message: message,
    iconPath: iconPath,
    backgroundColor: Theme.of(context).colorScheme.surface,
    backgroundColorBright: Theme.of(context).colorScheme.onSurface,
    textColor: Theme.of(context).colorScheme.onTertiary,
    iconColor: iconColor ?? Theme.of(context).colorScheme.onTertiary,
  );
}
