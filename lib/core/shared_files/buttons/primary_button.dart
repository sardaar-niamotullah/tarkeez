import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tarkeez/core/utils/text_utils.dart';

class PrimaryButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  final VoidCallback? onDisabled;
  final Color? backgroundColorLeft;
  final Color? backgroundColorRight;
  final Color textColor;
  final double height;
  final double width;
  final double borderRaius;
  final bool isBorderOn;
  final String? iconPath;
  final bool isLoading;
  final bool enable;
  final double? iconSize;

  const PrimaryButton({
    super.key,
    required this.title,
    required this.onPressed,
    this.backgroundColorLeft,
    this.backgroundColorRight,
    this.textColor = Colors.white,
    this.height = 43,
    this.width = double.infinity,
    this.borderRaius = 16,
    this.isBorderOn = false,
    this.iconPath,
    this.isLoading = false,
    this.enable = true,
    this.onDisabled,
    this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return ElevatedButton(
      onPressed: isLoading || !enable ? onDisabled : onPressed,
      style:
          ElevatedButton.styleFrom(
            elevation: 0,
            padding: .zero,
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            minimumSize: Size(width, height),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            shape: RoundedRectangleBorder(borderRadius: .circular(borderRaius)),
          ).copyWith(
            overlayColor: WidgetStateProperty.all(
              scheme.onTertiary.withValues(alpha: .1),
            ),
          ),
      child: Ink(
        height: height,
        width: width,
        decoration: BoxDecoration(
          borderRadius: .circular(borderRaius),
          border: .all(
            width: 1.5,
            color: textColor.withValues(alpha: isBorderOn ? 1 : 0),
          ),
          gradient: LinearGradient(
            begin: .centerLeft,
            end: .centerRight,
            colors: [
              backgroundColorLeft?.withValues(alpha: enable ? 1 : .45) ??
                  scheme.primaryContainer.withValues(alpha: enable ? 1 : .45),
              backgroundColorRight?.withValues(alpha: enable ? 1 : .45) ??
                  scheme.primary.withValues(alpha: enable ? 1 : .45),
            ],
          ),
        ),
        child: Center(
          child: isLoading
              ? SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: textColor,
                  ),
                )
              : Row(
                  mainAxisAlignment: .center,
                  children: [
                    if (iconPath != null) ...[
                      SvgPicture.asset(
                        iconPath!,
                        height: iconSize,
                        width: iconSize,
                        colorFilter: .mode(textColor, .srcIn),
                      ),
                      const SizedBox(width: 6),
                    ],
                    Text(
                      title,
                      style: TextUtils.title3(
                        context,
                        color: textColor.withValues(alpha: enable ? 1 : .65),
                      ),
                    ),
                    if (iconPath != null) const SizedBox(width: 6),
                  ],
                ),
        ),
      ),
    );
  }
}
