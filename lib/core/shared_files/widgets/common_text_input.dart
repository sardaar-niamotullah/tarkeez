import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tarkeez/core/constants/svg_paths.dart';
import 'package:tarkeez/core/theme/theme.dart';
import 'package:tarkeez/core/utils/container_design_utils.dart';
import 'package:tarkeez/core/utils/text_utils.dart';

class CommonTextInput extends StatelessWidget {
  final String label;
  final String? hintText;
  final String? errorText;
  final Color? backgroundColor;
  final int maxLines;
  final double borderRadius;
  final double borderWidth;
  final FloatingLabelBehavior labelBehavior;
  final String prefixIconPath;
  final bool readOnly;
  final VoidCallback? onTap;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardType;
  final bool isResetEnable;

  const CommonTextInput({
    super.key,
    required this.label,
    this.hintText,
    this.errorText,
    this.maxLines = 1,
    this.borderRadius = 16,
    this.borderWidth = 1.5,
    this.backgroundColor,
    this.labelBehavior = .auto,
    required this.prefixIconPath,
    this.readOnly = false,
    this.onTap,
    this.controller,
    this.onChanged,
    this.inputFormatters,
    this.keyboardType,
    this.isResetEnable = false,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return TextField(
      onTap: onTap,
      readOnly: readOnly,
      maxLines: maxLines,
      onChanged: onChanged,
      controller: controller,
      keyboardType: keyboardType,
      cursorOpacityAnimates: true,
      inputFormatters: inputFormatters,
      style: TextUtils.paragraph(context),
      cursorRadius: .circular(ContainerDesignUtils.radius),

      decoration: InputDecoration(
        isDense: true,
        filled: true,
        fillColor: backgroundColor ?? scheme.onSurface,
        floatingLabelBehavior: labelBehavior,

        contentPadding: const .symmetric(horizontal: 16, vertical: 16),

        labelText: label,
        labelStyle: TextUtils.paragraph(context, color: scheme.onTertiary),
        floatingLabelStyle: TextUtils.paragraph(
          context,
          color: scheme.onTertiary,
        ),
        alignLabelWithHint: true,

        hintText: hintText ?? label,
        hintStyle: TextUtils.paragraph(
          context,
          color: scheme.onTertiary.withValues(alpha: .75),
        ),
        errorText: errorText,

        prefixIcon: Padding(
          padding: const .all(8.0),
          child: SvgPicture.asset(
            prefixIconPath,
            colorFilter: .mode(
              scheme.onTertiary.withValues(alpha: .75),
              .srcIn,
            ),
          ),
        ),
        prefixIconConstraints: const BoxConstraints(
          minWidth: 36,
          minHeight: 36,
        ),

        suffixIcon: isResetEnable && (controller?.text.isNotEmpty ?? false)
            ? Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    controller?.clear();
                    FocusManager.instance.primaryFocus?.unfocus();
                    onChanged?.call('');
                  },
                  customBorder: const CircleBorder(),
                  child: SvgPicture.asset(
                    SvgPaths.closeLarge,
                    colorFilter: .mode(
                      scheme.onTertiary.withValues(alpha: .75),
                      .srcIn,
                    ),
                  ),
                ),
              )
            : null,
        suffixIconConstraints: const BoxConstraints(
          minWidth: 36,
          minHeight: 36,
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: .circular(borderRadius),
          borderSide: BorderSide(
            color: AppTheme.greyBright.withValues(alpha: .0),
            width: borderWidth,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: .circular(borderRadius),
          borderSide: BorderSide(
            color: scheme.primary.withValues(alpha: readOnly ? 0 : .75),
            width: borderWidth,
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: .circular(borderRadius),
          borderSide: BorderSide(
            color: AppTheme.greyBright,
            width: borderWidth,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: .circular(borderRadius),
          borderSide: BorderSide(color: scheme.error, width: borderWidth),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: .circular(borderRadius),
          borderSide: BorderSide(color: scheme.error, width: borderWidth),
        ),
      ),
    );
  }
}
