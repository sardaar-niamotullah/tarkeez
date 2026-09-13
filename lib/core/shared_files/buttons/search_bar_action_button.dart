import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SearchBarActionButton extends StatelessWidget {
  final VoidCallback onTap;
  final String iconPath;
  final double iconSize;
  final Color? backgroundColor;

  const SearchBarActionButton({
    super.key,
    required this.onTap,
    required this.iconPath,
    this.iconSize = 24,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Material(
      color: Colors.transparent,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Ink(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: backgroundColor ?? scheme.surface,
            shape: .circle,
          ),
          child: Center(
            child: SvgPicture.asset(
              iconPath,
              height: iconSize,
              colorFilter: .mode(
                scheme.onTertiary.withValues(alpha: .75),
                .srcIn,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
