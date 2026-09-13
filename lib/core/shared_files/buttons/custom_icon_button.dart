import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomIconButton extends StatelessWidget {
  final String iconPath;
  final VoidCallback onTap;
  final double? iconSize;
  final Color? backgroundColor, iconColor;
  const CustomIconButton({
    super.key,
    required this.iconPath,
    required this.onTap,
    this.iconSize,
    this.backgroundColor,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Ink(
          width: (iconSize ?? 24) + 12,
          height: (iconSize ?? 24) + 12,
          decoration: BoxDecoration(shape: .circle, color: backgroundColor),
          child: Center(
            child: SvgPicture.asset(
              iconPath,
              height: iconSize ?? 24,
              width: iconSize ?? 24,
              colorFilter: .mode(
                iconColor ?? Theme.of(context).colorScheme.onTertiary,
                .srcIn,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
