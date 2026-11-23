import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tarkeez/core/constants/asset_paths.dart';
import 'package:tarkeez/core/shared_files/widgets/bubble_decorations.dart';
import 'package:tarkeez/core/theme/theme.dart';
import 'package:tarkeez/core/utils/container_design_utils.dart';
import 'package:tarkeez/core/utils/text_utils.dart';

class PricingCard extends StatelessWidget {
  const new({
    super.key,
    required this.dealValue,
    required this.duration,
    required this.price,
    required this.saveAmount,
    required this.color,
    required this.colorBright,
    required this.iconPath,
    this.isActive = false,
    this.isBlocked = false,
    this.onTap,
  });

  final String dealValue;
  final String duration;
  final String price;
  final String saveAmount;
  final Color color;
  final Color colorBright;
  final String iconPath;
  final bool isActive, isBlocked;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    final bigStyle = TextUtils.title1(
      context,
      color: AppTheme.white,
    ).copyWith(fontSize: 28, fontWeight: .w800);
    final smallStyle = bigStyle.copyWith(fontSize: 16, fontWeight: .w600);

    final match = RegExp(r'\d[\d.,]*').firstMatch(price);

    return Opacity(
      opacity: isBlocked ? .5 : 1,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          mouseCursor: SystemMouseCursors.click,
          borderRadius: ContainerDesignUtils.allRadius,
          child: Ink(
            padding: .all(2),
            decoration: BoxDecoration(
              color: isActive ? scheme.onTertiary : Colors.transparent,
              borderRadius: ContainerDesignUtils.allRadius,
            ),
            child: ClipRRect(
              borderRadius: ContainerDesignUtils.allRadius,
              child: Ink(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: .topLeft,
                    end: .bottomRight,
                    colors: [colorBright, color],
                  ),
                  borderRadius: ContainerDesignUtils.allRadius,
                ),
                child: Stack(
                  alignment: .center,
                  clipBehavior: .hardEdge,
                  children: [
                    // ──────────────────────────────────────────────
                    // Content
                    // ──────────────────────────────────────────────
                    Padding(
                      padding: const .symmetric(vertical: 8),
                      child: Column(
                        mainAxisAlignment: .center,
                        children: [
                          Text(
                            dealValue,
                            style: TextUtils.paragraphBold(
                              context,
                              color: AppTheme.white,
                            ),
                          ),
                          const SizedBox(height: 8),

                          if (price == '')
                            SizedBox(
                              height: 34,
                              width: 40,
                              child: Center(
                                child: LinearProgressIndicator(
                                  minHeight: 3,
                                  color: AppTheme.white,
                                  backgroundColor: Colors.transparent,
                                  borderRadius: ContainerDesignUtils.allRadius,
                                ),
                              ),
                            )
                          else
                            Text.rich(
                              TextSpan(
                                children: match == null
                                    ? [TextSpan(text: price, style: bigStyle)]
                                    : [
                                        TextSpan(
                                          text: price.substring(0, match.start),
                                          style: smallStyle,
                                        ),
                                        TextSpan(
                                          text: match
                                              .group(0)!
                                              .replaceAll(
                                                RegExp(r'[.,]00?$'),
                                                '',
                                              ),
                                          style: bigStyle,
                                        ),
                                        TextSpan(
                                          text: price.substring(match.end),
                                          style: smallStyle,
                                        ),
                                      ],
                              ),
                            ),

                          Text(
                            duration,
                            style: TextUtils.paragraphBold(
                              context,
                              color: AppTheme.white,
                            ),
                          ),
                          const SizedBox(height: 12),

                          Container(
                            height: 20,
                            width: 108,
                            decoration: BoxDecoration(
                              color: AppTheme.black.withValues(alpha: .25),
                              borderRadius: ContainerDesignUtils.allRadius,
                            ),
                            child: Center(
                              child: Text(
                                saveAmount == '' ? '--' : saveAmount,
                                style: TextUtils.paragraphBold(
                                  context,
                                  color: AppTheme.white,
                                ),
                                textAlign: .center,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    if (isActive)
                      Positioned(
                        top: 10,
                        right: 10,
                        child: SvgPicture.asset(
                          height: 18,
                          AssetPaths.doneBold,
                          colorFilter: .mode(AppTheme.white, .srcIn),
                        ),
                      ),

                    if (isBlocked)
                      Positioned(
                        top: 10,
                        right: 10,
                        child: Icon(Icons.block, color: Colors.white, size: 18),
                      ),

                    /// BUBBLE — large, top-right (bleeds off edge)
                    Positioned(
                      top: -18,
                      right: -18,
                      child: BubbleSolid(
                        size: 70,
                        color: Colors.white,
                        opacity: 0.12,
                      ),
                    ),

                    /// BUBBLE — medium, bottom-left (bleeds off edge)
                    Positioned(
                      bottom: -14,
                      left: -14,
                      child: BubbleSolid(
                        size: 54,
                        color: Colors.white,
                        opacity: 0.10,
                      ),
                    ),

                    /// BUBBLE — small, top-left
                    Positioned(
                      top: 10,
                      left: 6,
                      child: BubbleSolid(
                        size: 20,
                        color: Colors.white,
                        opacity: 0.15,
                      ),
                    ),

                    /// BUBBLE — tiny, bottom-right
                    Positioned(
                      bottom: 12,
                      right: 10,
                      child: BubbleSolid(
                        size: 14,
                        color: Colors.white,
                        opacity: 0.18,
                      ),
                    ),

                    /// BUBBLE — ring, center-right
                    Positioned(
                      top: 38,
                      right: 8,
                      child: BubbleRing(
                        size: 30,
                        color: Colors.white,
                        opacity: 0.1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
