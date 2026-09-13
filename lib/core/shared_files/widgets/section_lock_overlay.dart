import 'package:flutter/material.dart';
import 'package:tarkeez/core/shared_files/widgets/section_overlay_lock_message_box.dart';
import 'package:tarkeez/core/utils/container_design_utils.dart';

class SectionLockOverlay extends StatelessWidget {
  const SectionLockOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return ClipRRect(
      borderRadius: ContainerDesignUtils.allRadius,
      child: BackdropFilter(
        blendMode: .src,
        filter: .blur(sigmaX: 5, sigmaY: 5),
        child: Container(
          width: .infinity,
          padding: .symmetric(horizontal: ContainerDesignUtils.padding),
          decoration: BoxDecoration(
            color: scheme.surface.withValues(alpha: .1),
            borderRadius: ContainerDesignUtils.allRadius,
            border: .all(
              color: scheme.onTertiary.withValues(alpha: 0.02),
              width: 1,
            ),
          ),
          child: Align(
            alignment: .centerEnd,
            child: const SectionOverlayLockMessageBox(),
          ),
        ),
      ),
    );
  }
}
