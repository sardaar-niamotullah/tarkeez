import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tarkeez/core/constants/svg_paths.dart';
import 'package:tarkeez/core/theme/theme.dart';
import 'package:tarkeez/core/utils/container_design_utils.dart';
import 'package:tarkeez/core/utils/text_utils.dart';

class SectionOverlayLockMessageBox extends StatelessWidget {
  const SectionOverlayLockMessageBox({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      height: 56,
      width: 248,
      padding: .only(left: ContainerDesignUtils.padding),
      decoration: BoxDecoration(
        color: scheme.onSurface.withValues(alpha: .3),
        borderRadius: ContainerDesignUtils.allRadius,
      ),
      child: Row(
        mainAxisAlignment: .end,
        children: [
          RichText(
            textAlign: .right,
            text: TextSpan(
              style: TextUtils.paragraphSmallBold(context),
              children: [
                const TextSpan(text: 'Become a '),
                TextSpan(
                  text: 'premium member',
                  style: TextUtils.paragraphSmallBold(
                    context,
                    color: AppTheme.fireTone,
                  ),
                ),
                const TextSpan(text: ' \nto unlock this insight.'),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            height: 56,
            width: 56,
            decoration: BoxDecoration(
              color: scheme.onSurface.withValues(alpha: .7),
              borderRadius: ContainerDesignUtils.allRadius,
            ),
            child: Center(
              child: SvgPicture.asset(
                SvgPaths.lock,
                height: 24,
                width: 24,
                colorFilter: .mode(scheme.onTertiary, .srcIn),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
