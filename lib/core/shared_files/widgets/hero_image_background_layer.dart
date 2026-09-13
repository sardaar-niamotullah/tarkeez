import 'package:flutter/material.dart';
import 'package:tarkeez/core/constants/img_paths.dart';

class HeroImageBackgroundLayer extends StatelessWidget {
  final Color? fillColor;
  final BoxFit? boxFit;
  const HeroImageBackgroundLayer({
    super.key,
    this.fillColor,
    this.boxFit = .fitWidth,
  });

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 1.1,
      widthFactor: 1.0,
      child: Stack(
        fit: .expand,
        children: [
          Image.asset(ImgPaths.heroImage, fit: boxFit, alignment: .topCenter),
          // Color overlay
          Container(
            color:
                fillColor ??
                Theme.of(context).colorScheme.primary.withValues(alpha: .7),
          ),
        ],
      ),
    );
  }
}
