import 'package:tarkeez/core/shared_files/widgets/bottom_navigation_animated_wrapper.dart';
import 'package:tarkeez/core/shared_files/widgets/custom_app_bar.dart';
import 'package:tarkeez/core/shared_files/widgets/hero_image_background_layer.dart';
import 'package:flutter/material.dart';
import 'package:tarkeez/core/utils/container_design_utils.dart';
import 'package:skeletonizer/skeletonizer.dart';

class StandAlonePageOuterStructure extends StatelessWidget {
  final String title;
  final List<Widget> actions;
  final Widget content;
  final Widget? bottomNavContent;
  final double? horizontalPadding;
  final Color? bgFillColor;
  final String? avatarLink, subtitle;
  final bool isBackButtonEnabled;
  final List<Widget> stackOverlays;
  final bool isLoading;
  final bool hasAvatarInAppBar;
  final Color? avatarCircleColor;

  const StandAlonePageOuterStructure({
    super.key,
    required this.title,
    required this.actions,
    required this.content,
    this.subtitle,
    this.avatarLink,
    this.bgFillColor,
    this.bottomNavContent,
    this.isLoading = false,
    this.avatarCircleColor,
    this.horizontalPadding,
    this.stackOverlays = const [],
    this.hasAvatarInAppBar = false,
    this.isBackButtonEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: scheme.surface,

      // ──────────────────────────────────────────────────────────
      // Bottom nav
      // ──────────────────────────────────────────────────────────
      bottomNavigationBar: bottomNavContent != null
          ? Skeletonizer(
              enabled: isLoading,
              child: BottomNavigationAnimatedWrapper(child: bottomNavContent!),
            )
          : null,

      // ──────────────────────────────────────────────────────────
      // Body
      // ──────────────────────────────────────────────────────────
      body: Stack(
        children: [
          // ──────────────────────────────────────────────────────────────
          // Hero background layer
          // ──────────────────────────────────────────────────────────────
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 400,
            child: HeroImageBackgroundLayer(fillColor: bgFillColor),
          ),

          SafeArea(
            bottom: false,
            child: Column(
              children: [
                // ──────────────────────────────────────────────────────────────
                // Custom app bar
                // ──────────────────────────────────────────────────────────────
                CustomAppBar(
                  title: title,
                  actions: actions,
                  isBackButtonEnabled: isBackButtonEnabled,
                  avatarLink: avatarLink,
                  subtitle: subtitle,
                ),

                // ──────────────────────────────────────────────────────────────
                // Content outer box
                // ──────────────────────────────────────────────────────────────
                Expanded(
                  child: Skeletonizer(
                    enabled: isLoading,
                    child: Container(
                      clipBehavior: Clip.hardEdge,
                      padding: .symmetric(
                        horizontal:
                            horizontalPadding ?? ContainerDesignUtils.margin,
                      ),
                      decoration: BoxDecoration(
                        color: scheme.surface,
                        borderRadius: ContainerDesignUtils.topRadius,
                      ),
                      child: content,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ──────────────────────────────────────────────────────────────
          // Stack overlays — FABs, banners, etc.
          // ──────────────────────────────────────────────────────────────
          ...stackOverlays,
        ],
      ),
    );
  }
}
