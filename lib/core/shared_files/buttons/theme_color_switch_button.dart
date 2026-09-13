import 'package:tarkeez/core/theme/theme.dart';
import 'package:flutter/material.dart';

class ThemeColorSwitchButton extends StatelessWidget {
  final Color themeColor;
  final VoidCallback onTap;
  final bool isActive;
  const ThemeColorSwitchButton({
    super.key,
    required this.themeColor,
    required this.onTap,
    this.isActive = false,
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
          child: Icon(
            Icons.done_rounded,
            size: 16,
            color: isActive ? AppTheme.white : Colors.transparent,
          ),
        ),
      ),
    );
  }
}
