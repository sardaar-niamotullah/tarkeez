import 'dart:io';
import 'package:tarkeez/core/constants/svg_paths.dart';
import 'package:tarkeez/core/theme/theme.dart';
import 'package:tarkeez/core/utils/container_design_utils.dart';
import 'package:tarkeez/core/utils/top_right_notch_clipper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ThumbnailWidget extends StatelessWidget {
  final File file;
  final VoidCallback onTap;
  final double height;
  final double aspectRatio;
  final Alignment alignment;

  const ThumbnailWidget({
    super.key,
    required this.file,
    required this.onTap,
    this.height = 144,
    this.aspectRatio = 1,
    this.alignment = .center,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final width = height * aspectRatio;

    return SizedBox(
      width: width,
      height: height,
      child: Stack(
        clipBehavior: .none,
        children: [
          ClipPath(
            clipper: TopRightNotchClipper(radius: 9.5, filletRadius: 2),
            child: ClipRRect(
              borderRadius: ContainerDesignUtils.allRadius,
              child: Image.file(
                file,
                fit: .cover,
                width: width,
                height: height,
                alignment: alignment,
              ),
            ),
          ),

          Positioned(
            top: -1,
            right: -1,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onTap,
                customBorder: const CircleBorder(),
                child: Ink(
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    color: scheme.error,
                    shape: .circle,
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      SvgPaths.close,
                      colorFilter: .mode(
                        AppTheme.white.withValues(alpha: .8),
                        .srcIn,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
