import 'package:flutter/material.dart';
import 'package:tarkeez/core/constants/img_paths.dart';
import 'package:tarkeez/core/utils/container_design_utils.dart';

class FreemiumProfileCover extends StatelessWidget {
  const FreemiumProfileCover({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      height: 100,
      width: .infinity,
      decoration: BoxDecoration(
        color: scheme.onSurface,
        borderRadius: ContainerDesignUtils.topRadius,
      ),
      child: Stack(
        children: [
          SizedBox(
            height: 100,
            width: .infinity,
            child: Image.asset(
              fit: .cover,
              alignment: .bottomCenter,
              ImgPaths.freemiumProfileCover,
            ),
          ),
          Container(
            height: 100,
            width: .infinity,
            color: scheme.primary.withValues(alpha: .25),
          ),
        ],
      ),
    );
  }
}
