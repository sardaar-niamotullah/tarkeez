import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:tarkeez/core/shared_files/widgets/section_overlay_lock_message_box.dart';
import 'package:tarkeez/core/utils/container_design_utils.dart';

class SectionImageLockOverlay extends StatelessWidget {
  const SectionImageLockOverlay({
    super.key,
    required this.imgLocation,
    required this.height,
    required this.lockedTopicName,
  });

  final String imgLocation, lockedTopicName;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: ContainerDesignUtils.allRadius,
          child: ImageFiltered(
            imageFilter: ImageFilter.blur(
              sigmaX: 5,
              sigmaY: 5,
              tileMode: .mirror,
            ),
            child: Container(
              height: height,
              width: .infinity,
              decoration: BoxDecoration(
                borderRadius: ContainerDesignUtils.allRadius,
                image: DecorationImage(
                  image: AssetImage(imgLocation),
                  fit: .cover,
                ),
              ),
            ),
          ),
        ),
        Positioned(
          top: 0,
          bottom: 0,
          right: 24,
          child: Center(
            child: SectionOverlayLockMessageBox(title: lockedTopicName),
          ),
        ),
      ],
    );
  }
}
