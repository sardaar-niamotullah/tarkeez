import 'package:tarkeez/core/shared_files/snackbar/snack_bar_public_api.dart';
import 'package:tarkeez/core/utils/container_design_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SelectFileSourceButton extends StatelessWidget {
  final String iconPath;
  final bool isActive;
  final VoidCallback? onTap;
  final double height;
  final Color? backgroundColorLight, backgroundColor, iconColor;
  const SelectFileSourceButton({
    super.key,
    required this.iconPath,
    required this.isActive,
    required this.onTap,
    this.height = 24,
    this.backgroundColorLight,
    this.backgroundColor,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isActive
            ? onTap
            : () => showWarningSnackBar(
                context,
                message: 'You can attach up to 3 images.',
              ),
        borderRadius: ContainerDesignUtils.allRadius,
        splashColor: scheme.primary.withValues(alpha: 0.1),
        highlightColor: scheme.primary.withValues(alpha: 0.15),
        child: Ink(
          height: 60,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                backgroundColorLight ?? scheme.onSurface,
                backgroundColor ?? scheme.onSurface,
              ],
            ),
            borderRadius: ContainerDesignUtils.allRadius,
          ),
          child: Center(
            child: SvgPicture.asset(
              iconPath,
              height: height,
              colorFilter: .mode(
                iconColor ??
                    scheme.onTertiary.withValues(alpha: isActive ? 0.85 : 0.25),
                .srcIn,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
