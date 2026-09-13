import 'package:cached_network_image/cached_network_image.dart';
import 'package:tarkeez/core/constants/svg_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ShowNetworkImage extends StatelessWidget {
  final String imageUrl;
  final double size;
  const ShowNetworkImage({
    super.key,
    required this.imageUrl,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: .cover,
      width: size,
      height: size,
      fadeInDuration: .zero,
      fadeOutDuration: .zero,
      placeholder: (context, url) => Center(
        child: SizedBox(
          height: size / 2.5,
          width: size / 2.5,
          child: CircularProgressIndicator(
            color: scheme.tertiary,
            strokeWidth: 2,
            strokeCap: .round,
          ),
        ),
      ),
      errorWidget: (context, url, error) => Center(
        child: SvgPicture.asset(
          SvgPaths.exclamation,
          height: size / 1.5,
          width: size / 1.5,
          colorFilter: .mode(Theme.of(context).colorScheme.onSurface, .srcIn),
        ),
      ),
    );
  }
}
