import 'package:cached_network_image/cached_network_image.dart';
import 'package:tarkeez/core/constants/svg_paths.dart';
import 'package:tarkeez/core/theme/theme.dart';
import 'package:tarkeez/core/utils/container_design_utils.dart';
import 'package:tarkeez/core/utils/text_utils.dart';
import 'package:tarkeez/core/utils/top_right_notch_clipper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class AvatarMagnifierWindow extends StatelessWidget {
  final String title;
  final String? imageUrl;
  final Color? backgroundColor;

  const AvatarMagnifierWindow({
    super.key,
    required this.title,
    this.backgroundColor,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        ClipPath(
          clipper: TopRightNotchClipper(radius: 11.5, filletRadius: 2),
          child: Container(
            padding: const .all(ContainerDesignUtils.radius),
            decoration: BoxDecoration(
              color: scheme.surface,
              borderRadius: ContainerDesignUtils.allRadius,
            ),
            child: ClipRRect(
              borderRadius: ContainerDesignUtils.allRadius,
              child: (imageUrl == null)
                  ? AspectRatio(
                      aspectRatio: 1,
                      child: Container(
                        width: .infinity,
                        decoration: BoxDecoration(
                          color: backgroundColor ?? scheme.primary,
                        ),
                        child: Center(
                          child: Text(
                            title.toUpperCase()[0],
                            style: TextUtils.title3(
                              context,
                              color: AppTheme.white,
                            ).copyWith(fontSize: 124),
                          ),
                        ),
                      ),
                    )
                  : AspectRatio(
                      aspectRatio: 1,
                      child: CachedNetworkImage(
                        fit: .cover,
                        imageUrl: imageUrl ?? '',
                        fadeInDuration: .zero,
                        fadeOutDuration: .zero,
                        placeholder: (context, url) => Center(
                          child: CircularProgressIndicator(
                            color: scheme.tertiary,
                            strokeWidth: 2,
                            strokeCap: .round,
                          ),
                        ),
                        errorWidget: (context, url, error) => Center(
                          child: SvgPicture.asset(
                            SvgPaths.exclamation,
                            colorFilter: .mode(
                              Theme.of(context).colorScheme.onSurface,
                              .srcIn,
                            ),
                          ),
                        ),
                      ),
                    ),
            ),
          ),
        ),

        Positioned(
          top: -1,
          right: -1,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => context.pop(),
              customBorder: const CircleBorder(),
              child: Ink(
                width: 26,
                height: 26,
                decoration: BoxDecoration(color: scheme.error, shape: .circle),
                child: Center(
                  child: SvgPicture.asset(
                    SvgPaths.close,
                    height: 42,
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
    );
  }
}
