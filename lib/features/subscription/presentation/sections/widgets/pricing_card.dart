import 'package:flutter/material.dart';
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
    this.onTap,
  });

  final String dealValue;
  final String duration;
  final String price;
  final String saveAmount;
  final Color color;
  final Color colorBright;
  final String iconPath;
  final bool isActive;
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

    return Material(
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
                                          .replaceAll(RegExp(r'[.,]00?$'), ''),
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
                              saveAmount,
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
                    top: 28,
                    right: 8,
                    child: BubbleRing(
                      size: 30,
                      color: Colors.white,
                      opacity: 0.15,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
