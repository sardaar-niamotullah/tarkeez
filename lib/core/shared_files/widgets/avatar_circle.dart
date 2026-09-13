import 'dart:io';
import 'package:tarkeez/core/shared_files/widgets/show_network_image.dart';
import 'package:tarkeez/core/theme/theme.dart';
import 'package:tarkeez/core/utils/text_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tarkeez/core/constants/svg_paths.dart';

class AvatarCircle extends StatelessWidget {
  final bool isEditable;
  final double radius;
  final double? innerRadius;
  final String? imageUrl;
  final VoidCallback? onTap;
  final bool? isLoading;
  final File? localImageFile;
  final Color? outerCircleColor;
  final Color? innerCircleColor;
  final String? name;

  const AvatarCircle({
    super.key,
    required this.isEditable,
    this.radius = 40,
    this.innerRadius,
    this.imageUrl,
    this.onTap,
    this.isLoading,
    this.localImageFile,
    this.outerCircleColor,
    this.innerCircleColor,
    this.name,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Material(
          color: Colors.transparent,
          shape: const CircleBorder(),
          child: InkWell(
            onTap: onTap,
            customBorder: const CircleBorder(),
            child: Ink(
              width: radius * 2,
              height: radius * 2,
              decoration: BoxDecoration(
                color: outerCircleColor ?? scheme.onSurface,
                shape: .circle,
              ),
              child: Center(
                child: Ink(
                  width: (innerRadius ?? (radius - 2)) * 2,
                  height: (innerRadius ?? (radius - 2)) * 2,
                  decoration: BoxDecoration(
                    shape: .circle,
                    color:
                        innerCircleColor ??
                        scheme.onTertiary.withValues(alpha: .5),
                  ),
                  child: Center(
                    child: ClipOval(
                      child: _buildAvatarContent(context, scheme),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        if (isEditable)
          Positioned(
            bottom: 8,
            right: 8,
            child: Material(
              color: Colors.transparent,
              shape: const CircleBorder(),
              child: InkWell(
                onTap: onTap,
                customBorder: const CircleBorder(),
                child: Ink(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: outerCircleColor ?? scheme.surface,
                    shape: .circle,
                  ),
                  child: Center(
                    child: Icon(Icons.edit, size: 10, color: scheme.primary),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildAvatarContent(BuildContext context, ColorScheme scheme) {
    final size = (radius - 2) * 2;

    if (localImageFile != null) {
      return Image.file(
        localImageFile!,
        fit: .cover,
        width: size,
        height: size,
        errorBuilder: (context, error, stackTrace) => SvgPicture.asset(
          SvgPaths.exclamation,
          colorFilter: .mode(Theme.of(context).colorScheme.onSurface, .srcIn),
        ),
      );
    }

    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return ShowNetworkImage(imageUrl: imageUrl!, size: size);
    }

    if (isLoading == true) {
      return SizedBox(
        height: size / 2.5,
        width: size / 2.5,
        child: CircularProgressIndicator(
          color: scheme.tertiary,
          strokeWidth: 4,
          strokeCap: .round,
        ),
      );
    }

    if (name != null) {
      return Text(
        name!.toUpperCase()[0],
        style: TextUtils.title3(
          context,
          color: AppTheme.white,
        ).copyWith(fontSize: radius),
      );
    }

    return SvgPicture.asset(
      SvgPaths.user,
      height: radius,
      colorFilter: .mode(scheme.tertiary.withValues(alpha: .85), .srcIn),
    );
  }
}
