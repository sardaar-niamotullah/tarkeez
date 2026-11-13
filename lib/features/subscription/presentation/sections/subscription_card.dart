import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tarkeez/core/routes/route_names.dart';
import 'package:tarkeez/core/shared_files/cubits/premium_cubit.dart';
import 'package:tarkeez/core/shared_files/widgets/bubble_decorations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tarkeez/core/constants/svg_paths.dart';
import 'package:tarkeez/core/theme/theme.dart';
import 'package:tarkeez/core/utils/container_design_utils.dart';
import 'package:tarkeez/core/utils/duration_text_utils.dart';
import 'package:tarkeez/core/utils/text_utils.dart';

class SubscriptionCard extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final premiumUntil = context.select((PremiumCubit c) => c.state);
    final secondsLeft = premiumUntil?.difference(DateTime.now()).inSeconds ?? 0;
    final isPremiumUser = secondsLeft > 0;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          context.pop();
          context.push(RouteNames.subscriptionPage);
        },
        mouseCursor: SystemMouseCursors.click,
        borderRadius: ContainerDesignUtils.allRadius,
        child: Ink(
          decoration: BoxDecoration(
            color: scheme.primary,
            borderRadius: ContainerDesignUtils.allRadius,
            gradient: LinearGradient(
              begin: .topLeft,
              end: .bottomRight,
              colors: [AppTheme.fireTone, AppTheme.lightningGold],
            ),
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

                /// Tiny — bottom-right, inside
                Positioned(
                  bottom: 8,
                  right: 12,
                  child: BubbleSolid(
                    size: 12,
                    color: Colors.white,
                    opacity: 0.18,
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
                Container(
                  padding: .all(12),
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        SvgPaths.medalBold,
                        colorFilter: .mode(AppTheme.white, .srcIn),
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: .start,
                        children: [
                          Text(
                            isPremiumUser
                                ? 'Premium membership'
                                : ' Go premium',
                            style: TextUtils.paragraphBold(
                              context,
                              color: AppTheme.white,
                            ),
                          ),
                          if (isPremiumUser)
                            Row(
                              children: [
                                Transform.translate(
                                  offset: Offset(0, 1),
                                  child: Text(
                                    'Expires in ',
                                    style: TextUtils.paragraphSmall(
                                      context,
                                      color: AppTheme.white.withValues(
                                        alpha: .8,
                                      ),
                                    ),
                                  ),
                                ),
                                DurationTextUtils(
                                  durationInSeconds: secondsLeft,
                                  showDayHour: true,
                                  fontSizePrimary: 14,
                                  fontSizeSeconday: 12,
                                  fontColorPrimary: AppTheme.white,
                                  fontColorSecondary: AppTheme.white,
                                ),
                              ],
                            ),
                        ],
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
