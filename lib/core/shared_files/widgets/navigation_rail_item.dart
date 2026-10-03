import 'package:flutter/material.dart';
import 'package:tarkeez/core/utils/container_design_utils.dart';
import 'package:tarkeez/core/utils/text_utils.dart';
import 'package:tarkeez/features/home/presentation/sections/widgets/bottom_nav_bar_icon.dart';

class NavigationRailItem extends StatelessWidget {
  const NavigationRailItem({
    super.key,
    required this.onTap,
    required this.isActive,
    required this.label,
    required this.iconPath,
  });

  final VoidCallback onTap;
  final bool isActive;
  final String iconPath;
  final String label;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: .symmetric(
        horizontal: ContainerDesignUtils.halfPadding,
        vertical: ContainerDesignUtils.quarterPadding,
      ),
      child: InkWell(
        onTap: () => onTap(),
        mouseCursor: SystemMouseCursors.click,
        borderRadius: .circular(ContainerDesignUtils.radius),
        splashFactory: InkRipple.splashFactory,
        splashColor: scheme.primary.withValues(alpha: .01),
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
        child: Padding(
          padding: const .symmetric(vertical: 10, horizontal: 4),
          child: Column(
            mainAxisSize: .min,
            children: [
              BottomNavBarIcon(iconPath: iconPath, isActive: isActive),
              const SizedBox(height: 4),
              Text(
                label,
                textAlign: .center,
                style: TextUtils.paragraphSmallBold(
                  context,
                  color: isActive ? scheme.primaryContainer : scheme.onTertiary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
