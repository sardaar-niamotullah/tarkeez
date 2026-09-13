import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tarkeez/core/constants/svg_paths.dart';
import 'package:tarkeez/core/utils/color_from_hex_code.dart';
import 'package:tarkeez/features/projects/data/models/project_color_model.dart';

class ProjectColorSelectionBox extends StatelessWidget {
  final ProjectColorModel color;
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
              color: colorFromHexCode(color.hexCode).withValues(alpha: .25),
            ),
            child: Ink(
              decoration: BoxDecoration(
                shape: .circle,
                color: colorFromHexCode(color.hexCode),
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
