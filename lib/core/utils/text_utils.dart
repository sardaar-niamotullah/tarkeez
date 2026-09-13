import 'package:flutter/material.dart';
import 'package:tarkeez/core/theme/app_fonts.dart';

class TextUtils {
  static TextStyle title1(
    BuildContext context, {
    Color? color,
    AppFontFamily fontFamily = AppFontFamily.sourceSans,
  }) {
    return AppFonts.font(
      size: 24,
      weight: .w600,
      color:
          color ??
          Theme.of(context).colorScheme.onTertiary.withValues(alpha: .9),
      height: 1.2,
      fontFamily: fontFamily,
    );
  }

  static TextStyle title1Normal(BuildContext context, {Color? color}) {
    return AppFonts.font(
      size: 20,
      weight: .bold,
      color:
          color ??
          Theme.of(context).colorScheme.onTertiary.withValues(alpha: .9),
      height: 1.2,
    );
  }

  static TextStyle title2(BuildContext context, {Color? color}) {
    return AppFonts.font(
      size: 18,
      weight: .bold,
      height: 1.2,
      color:
          color ??
          Theme.of(context).colorScheme.onTertiary.withValues(alpha: .9),
    );
  }

  static TextStyle title2Normal(BuildContext context, {Color? color}) {
    return AppFonts.font(
      size: 18,
      weight: .normal,
      height: 1.1,
      color:
          color ??
          Theme.of(context).colorScheme.onTertiary.withValues(alpha: .9),
    );
  }

  static TextStyle title3(BuildContext context, {Color? color}) {
    return AppFonts.font(
      size: 16,
      weight: .bold,
      height: 1.2,
      color:
          color ??
          Theme.of(context).colorScheme.onTertiary.withValues(alpha: .9),
    );
  }

  static TextStyle title3Normal(BuildContext context, {Color? color}) {
    return AppFonts.font(
      size: 16,
      weight: .w600,
      height: 1.2,
      color:
          color ??
          Theme.of(context).colorScheme.onTertiary.withValues(alpha: .9),
    );
  }

  static TextStyle paragraph(BuildContext context, {Color? color}) {
    return AppFonts.font(
      size: 14,
      weight: .normal,
      height: 1.3,
      color:
          color ??
          Theme.of(context).colorScheme.onTertiary.withValues(alpha: .9),
    );
  }

  static TextStyle paragraphBold(BuildContext context, {Color? color}) {
    return AppFonts.font(
      size: 14,
      weight: .bold,
      height: 1.2,
      color:
          color ??
          Theme.of(context).colorScheme.onTertiary.withValues(alpha: .9),
    );
  }

  static TextStyle paragraphSmall(BuildContext context, {Color? color}) {
    return AppFonts.font(
      size: 12,
      weight: .normal,
      height: 1.2,
      color:
          color ??
          Theme.of(context).colorScheme.onTertiary.withValues(alpha: .9),
    );
  }

  static TextStyle paragraphXs(BuildContext context, {Color? color}) {
    return AppFonts.font(
      size: 10,
      weight: .normal,
      height: 1.2,
      color:
          color ??
          Theme.of(context).colorScheme.onTertiary.withValues(alpha: .9),
    );
  }

  static TextStyle paragraphXsBold(BuildContext context, {Color? color}) {
    return AppFonts.font(
      size: 10,
      weight: .bold,
      height: 1.2,
      color:
          color ??
          Theme.of(context).colorScheme.onTertiary.withValues(alpha: .9),
    );
  }

  static TextStyle paragraphSmallBold(BuildContext context, {Color? color}) {
    return AppFonts.font(
      size: 12,
      weight: .bold,
      height: 1.2,
      color:
          color ??
          Theme.of(context).colorScheme.onTertiary.withValues(alpha: .9),
    );
  }
}
