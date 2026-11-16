import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tarkeez/core/constants/asset_paths.dart';
import 'package:tarkeez/core/theme/theme.dart';

class ProjectColorSelectionBox extends StatelessWidget {
  const new({
    super.key,
    required this.color,
    required this.onTap,
    this.isSelected = false,
  });

  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        mouseCursor: SystemMouseCursors.click,
        customBorder: const CircleBorder(),
        child: AspectRatio(
          aspectRatio: 1,
          child: Ink(
            padding: .all(2),
            decoration: BoxDecoration(
              shape: .circle,
              color: color.withValues(alpha: .25),
            ),
            child: Ink(
              decoration: BoxDecoration(shape: .circle, color: color),
              child: Center(
                child: SvgPicture.asset(
                  AssetPaths.doneOutline,
                  height: 22,
                  colorFilter: .mode(
                    isSelected ? AppTheme.white : Colors.transparent,
                    .srcIn,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
