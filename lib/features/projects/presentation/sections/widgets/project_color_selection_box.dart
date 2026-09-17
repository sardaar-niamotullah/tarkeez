import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tarkeez/core/constants/svg_paths.dart';

class ProjectColorSelectionBox extends StatelessWidget {
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;
  const ProjectColorSelectionBox({
    super.key,
    required this.color,
    required this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
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
              decoration: BoxDecoration(
                shape: .circle,
                color: color,
              ),
              child: Center(
                child: SvgPicture.asset(
                  SvgPaths.doneOutline,
                  height: 24,
                  colorFilter: .mode(
                    isSelected ? scheme.onTertiary : Colors.transparent,
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
