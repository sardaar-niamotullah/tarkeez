import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tarkeez/core/constants/svg_paths.dart';
import 'package:tarkeez/core/theme/theme.dart';
import 'package:tarkeez/core/utils/container_design_utils.dart';
import 'package:tarkeez/core/utils/text_utils.dart';

class EdgeActionButton extends StatelessWidget {
  final String label, iconPath;
  final Color? backgroundColor;
  final VoidCallback onTap;
  final bool isCollapsed;
  final Animation<double>? collapseAnimation;

  const EdgeActionButton({
    super.key,
    required this.label,
    this.backgroundColor,
    required this.onTap,
    this.isCollapsed = false,
    this.iconPath = SvgPaths.taka,
    this.collapseAnimation,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final radius = ContainerDesignUtils.leftRadius;

    // Animate horizontal padding: 16 → 0 as controller goes 0 → 1
    final hPadAnim = collapseAnimation != null
        ? Tween<double>(begin: 16, end: 0).animate(
            CurvedAnimation(
              parent: collapseAnimation!,
              curve: Curves.easeInOut,
            ),
          )
        : null;

    return Align(
      alignment: .centerRight,
      child: Material(
        color: Colors.transparent,
        borderRadius: radius,
        clipBehavior: .antiAlias,
        child: InkWell(
          onTap: onTap,
          borderRadius: radius,
          child: AnimatedBuilder(
            animation: collapseAnimation ?? const AlwaysStoppedAnimation(0),
            builder: (context, _) {
              final hPad = hPadAnim?.value ?? 24.0;
              return Ink(
                width: 168,
                padding: .symmetric(horizontal: hPad, vertical: 16),
                decoration: BoxDecoration(
                  color: backgroundColor ?? scheme.onTertiary,
                  borderRadius: radius,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.25),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(
                      iconPath,
                      height: 34,
                      colorFilter: .mode(
                        backgroundColor != null
                            ? AppTheme.white
                            : scheme.tertiary,
                        .srcIn,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      label,
                      style: TextUtils.title3(
                        context,
                        color: backgroundColor != null
                            ? AppTheme.white
                            : scheme.tertiary,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
