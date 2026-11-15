import 'package:go_router/go_router.dart';
import 'package:tarkeez/core/routes/route_names.dart';
import 'package:tarkeez/core/shared_files/widgets/bubble_decorations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tarkeez/core/constants/svg_paths.dart';
import 'package:tarkeez/core/theme/theme.dart';
import 'package:tarkeez/core/utils/container_design_utils.dart';
import 'package:tarkeez/core/utils/text_utils.dart';

class UpdateAppCard extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      margin: const .only(top: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            // context.pop();
            // context.push(RouteNames.subscriptionPage);
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
                colors: [scheme.primary, scheme.primaryContainer],
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
                    padding: .symmetric(horizontal: 12, vertical: 6),
                    child: Row(
                      mainAxisAlignment: .center,
                      children: [
                        SvgPicture.asset(
                          SvgPaths.download,
                          colorFilter: .mode(AppTheme.white, .srcIn),
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Update available',
                          style: TextUtils.paragraphBold(
                            context,
                            color: AppTheme.white,
                          ),
                        ),
                      ],
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
