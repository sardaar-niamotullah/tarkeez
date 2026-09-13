import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:tarkeez/core/constants/svg_paths.dart';
import 'package:tarkeez/core/routes/route_names.dart';
import 'package:tarkeez/core/shared_files/widgets/bubble_decorations.dart';
import 'package:tarkeez/core/theme/theme.dart';
import 'package:tarkeez/core/utils/container_design_utils.dart';
import 'package:tarkeez/core/utils/text_utils.dart';

class GoPremiumButton extends StatelessWidget {
  const GoPremiumButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => context.push(RouteNames.subscriptionPage),
        borderRadius: ContainerDesignUtils.allRadius,
        child: Ink(
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
                  child: BubbleSolid(
                    size: 60,
                    color: Colors.white,
                    opacity: 0.12,
                  ),
                ),

                /// Medium — bottom-left, bleeding off edge
                Positioned(
                  bottom: -12,
                  left: -12,
                  child: BubbleSolid(
                    size: 48,
                    color: Colors.white,
                    opacity: 0.10,
                  ),
                ),

                /// Small — top-left, inside
                Positioned(
                  top: 8,
                  left: 48,
                  child: BubbleSolid(
                    size: 16,
                    color: Colors.white,
                    opacity: 0.15,
                  ),
                ),

                /// Ring — center-right area
                Positioned(
                  top: 10,
                  right: 44,
                  child: BubbleRing(
                    size: 26,
                    color: Colors.white,
                    opacity: 0.15,
                  ),
                ),
                // ── Content ──────────────────────────────────────
                Ink(
                  padding: .symmetric(
                    horizontal: ContainerDesignUtils.padding,
                    vertical: ContainerDesignUtils.halfPadding,
                  ),
                  child: Row(
                    mainAxisSize: .min,
                    crossAxisAlignment: .center,
                    children: [
                      Text(
                        'Go premium',
                        style: TextUtils.paragraphBold(
                          context,
                          color: AppTheme.white,
                        ),
                      ),
                      const SizedBox(width: 6),
                      SvgPicture.asset(
                        SvgPaths.medal,
                        colorFilter: .mode(AppTheme.white, .srcIn),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
