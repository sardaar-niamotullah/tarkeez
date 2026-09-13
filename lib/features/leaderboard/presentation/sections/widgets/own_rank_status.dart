import 'package:flutter/material.dart';
import 'package:tarkeez/core/shared_files/widgets/avatar_circle.dart';
import 'package:tarkeez/core/shared_files/widgets/bubble_decorations.dart';
import 'package:tarkeez/core/shared_files/widgets/time_chip.dart';
import 'package:tarkeez/core/theme/theme.dart';
import 'package:tarkeez/core/utils/container_design_utils.dart';
import 'package:tarkeez/core/utils/text_utils.dart';

class OwnRankStatus extends StatelessWidget {
  const OwnRankStatus({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: .topLeft,
          end: .bottomRight,
          colors: [AppTheme.fireTone, AppTheme.lightningGold],
        ),
        borderRadius: ContainerDesignUtils.allRadius,
      ),
      child: ClipRRect(
        borderRadius: ContainerDesignUtils.allRadius,
        child: Stack(
          alignment: .center,
          clipBehavior: .hardEdge,
          children: [
            // ── Bubbles ──────────────────────────────────────
            /// Large — top-right, bleeding off edge
            Positioned(
              top: -16,
              right: -16,
              child: BubbleSolid(size: 60, color: Colors.white, opacity: 0.12),
            ),

            /// Medium — bottom-left, bleeding off edge
            Positioned(
              bottom: -12,
              left: -12,
              child: BubbleSolid(size: 48, color: Colors.white, opacity: 0.10),
            ),

            /// Small — top-left, inside
            Positioned(
              top: 8,
              left: 48,
              child: BubbleSolid(size: 16, color: Colors.white, opacity: 0.15),
            ),

            // ── Content ──────────────────────────────────────
            Padding(
              padding: const .symmetric(vertical: 4, horizontal: 8),
              child: Row(
                mainAxisSize: .min,
                mainAxisAlignment: .end,
                children: [
                  Flexible(
                    child: Column(
                      mainAxisSize: .min,
                      crossAxisAlignment: .end,
                      children: [
                        Row(
                          mainAxisSize: .min,
                          textBaseline: .alphabetic,
                          crossAxisAlignment: .baseline,
                          children: [
                            Text(
                              '323,232',
                              style: TextUtils.paragraphSmallBold(
                                context,
                                color: scheme.tertiary,
                              ),
                            ),
                            Text(
                              'th',
                              style: TextUtils.paragraphSmallBold(context)
                                  .copyWith(
                                    fontSize: 10,
                                    color: scheme.tertiary.withValues(
                                      alpha: .6,
                                    ),
                                  ),
                            ),
                          ],
                        ),
                        TimeChip(seconds: 4234, fontColor: scheme.tertiary),
                        Text(
                          'You',
                          style: TextUtils.paragraphSmallBold(
                            context,
                            color: scheme.tertiary,
                          ).copyWith(fontSize: 10),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  AvatarCircle(
                    isEditable: false,
                    radius: 18,
                    outerCircleColor: scheme.surface,
                    imageUrl:
                        'https://lh3.googleusercontent.com/a/ACg8ocJiOW7MX3yx9yEdIedMxgIEw3R5LtEMI_k2UOpH6xOqAKIHgkcHkg=s576-c-no',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
