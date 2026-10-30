import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ActionButton extends StatelessWidget {
  const new({
    super.key,
    required this.iconPath,
    this.iconSize = 18,
    this.boxSize = 32,
    this.iconColor,
    this.backgroundColor,
    required this.onTap,
  });

  final String iconPath;
  final double iconSize, boxSize;
  final Color? iconColor, backgroundColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        mouseCursor: SystemMouseCursors.click,
        child: Ink(
          height: boxSize,
          width: boxSize,
          decoration: BoxDecoration(
            color: backgroundColor ?? scheme.tertiary,
            shape: .circle,
          ),
          child: Center(
            child: SvgPicture.asset(
              iconPath,
              height: iconSize,
              width: iconSize,
              colorFilter: .mode(
                iconColor ?? scheme.onTertiary.withValues(alpha: 0.9),
                .srcIn,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
