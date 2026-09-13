import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tarkeez/core/constants/svg_paths.dart';
import 'package:tarkeez/core/extensions/string_extension.dart';
import 'package:tarkeez/core/utils/container_design_utils.dart';
import 'package:tarkeez/features/profile/presentation/sections/widgets/freemium_profile_cover.dart';

class UserCoverPic extends StatelessWidget {
  final String? imageUrl;
  final bool isEditable, isPremiumUser, isLoading;
  final VoidCallback onTap;
  final File? localImageFile;

  const UserCoverPic({
    super.key,
    required this.onTap,
    this.imageUrl,
    this.isEditable = false,
    this.isPremiumUser = true,
    this.isLoading = false,
    this.localImageFile,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    if (localImageFile == null && isLoading) {
      return LinearProgressIndicator(
        minHeight: 100,
        color: scheme.surface,
        backgroundColor: scheme.onSurface,
        borderRadius: ContainerDesignUtils.allRadius,
      );
    }

    return Stack(
      children: [
        if (localImageFile != null) ...[
          ClipRRect(
            borderRadius: ContainerDesignUtils.topRadius,
            child: Image.file(
              localImageFile!,
              height: 100,
              fit: .cover,
              width: .infinity,
              alignment: .center,
              errorBuilder: (context, error, stackTrace) => Container(
                height: 100,
                color: scheme.onSurface,
                child: Center(
                  child: SvgPicture.asset(
                    SvgPaths.exclamation,
                    height: 60,
                    width: 60,
                    colorFilter: .mode(scheme.primary, .srcIn),
                  ),
                ),
              ),
            ),
          ),
          Container(height: 100, color: scheme.primary.withValues(alpha: .1)),
        ] else if (!isPremiumUser ||
            imageUrl.returnNullIfStringIsEmpty == null) ...[
          const FreemiumProfileCover(),
        ] else ...[
          Container(
            height: 100,
            width: .infinity,
            decoration: BoxDecoration(
              color: scheme.onSurface,
              borderRadius: ContainerDesignUtils.topRadius,
            ),
            child: ClipRRect(
              borderRadius: ContainerDesignUtils.topRadius,
              child: CachedNetworkImage(
                imageUrl: imageUrl ?? '',
                fit: .cover,
                alignment: .center,
                fadeInDuration: .zero,
                fadeOutDuration: .zero,
                placeholder: (context, url) => LinearProgressIndicator(
                  minHeight: 100,
                  color: scheme.surface,
                  backgroundColor: scheme.onSurface,
                  borderRadius: ContainerDesignUtils.allRadius,
                ),
                errorWidget: (context, url, error) => Center(
                  child: SvgPicture.asset(
                    SvgPaths.exclamation,
                    height: 60,
                    width: 60,
                    colorFilter: .mode(scheme.primary, .srcIn),
                  ),
                ),
              ),
            ),
          ),
          Container(height: 100, color: scheme.primary.withValues(alpha: .1)),
        ],
        if (isEditable)
          Positioned(
            top: 8,
            right: 8,
            child: Material(
              color: Colors.transparent,
              shape: const CircleBorder(),
              child: InkWell(
                onTap: onTap,
                customBorder: const CircleBorder(),
                child: Ink(
                  width: 18,
                  height: 18,
                  decoration: BoxDecoration(
                    shape: .circle,
                    color: scheme.onSurface,
                  ),
                  child: Center(
                    child: Icon(Icons.edit, size: 12, color: scheme.primary),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
