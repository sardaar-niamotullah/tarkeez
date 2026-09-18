import 'package:flutter_svg/svg.dart';
import 'package:tarkeez/core/constants/svg_paths.dart';
import 'package:flutter/material.dart';

class ThemeColorSwitchButton extends StatelessWidget {
  final Color themeColor;
  final VoidCallback onTap;
  final bool isActive;
  final bool isLocked;
  const ThemeColorSwitchButton({
    super.key,
    required this.themeColor,
    required this.onTap,
    this.isActive = false,
    this.isLocked = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Ink(
          height: 22,
          width: 22,
          decoration: BoxDecoration(color: themeColor, shape: .circle),
          child: Center(
            child: SvgPicture.asset(
              height: 12,
              width: 12,
              SvgPaths.doneOutline,
              colorFilter: .mode(
                Theme.of(context).colorScheme.onTertiary
                    .withValues(alpha: isActive ? 1 : 0),
                .srcIn,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
