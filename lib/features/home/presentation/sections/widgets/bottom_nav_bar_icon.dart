import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class BottomNavBarIcon extends StatelessWidget {
  final String iconPath;
  final bool isActive;
  final double size;

  const BottomNavBarIcon({
    super.key,
    required this.iconPath,
    required this.isActive,
    this.size = 24,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return SvgPicture.asset(
      iconPath,
      width: size,
      height: size,
      colorFilter: .mode(
        isActive ? scheme.primary : scheme.onTertiary.withValues(alpha: .75),
        .srcIn,
      ),
    );
  }
}
