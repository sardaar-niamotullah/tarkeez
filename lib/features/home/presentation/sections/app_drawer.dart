import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tarkeez/core/shared_files/buttons/theme_switch_button.dart';
import 'package:tarkeez/core/utils/container_design_utils.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tarkeez/core/constants/svg_paths.dart';
import 'package:tarkeez/core/routes/route_names.dart';
import 'package:tarkeez/core/utils/text_utils.dart';
import 'package:tarkeez/features/home/presentation/sections/widgets/app_drawer_item.dart';
import 'package:tarkeez/features/settings/presentation/settings_bottom_sheet.dart';
import 'package:tarkeez/features/subscription/presentation/sections/subscription_card.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Drawer(
      child: SafeArea(
        child: Container(
          padding: const .only(top: 24, left: 16, right: 16),
          child: Column(
            crossAxisAlignment: .start,
            children: [
              // ──────────────────────────────────────────────
              // Menu title, Theme and Language switch button
              // ──────────────────────────────────────────────
              Row(
                mainAxisAlignment: .spaceBetween,
                children: [
                  Row(
                    children: [
                      Material(
                        color: Colors.transparent,
                        child: Ink(
                          height: 36,
                          width: 36,
                          decoration: BoxDecoration(
                            color: scheme.primary,
                            borderRadius: ContainerDesignUtils.allHalfRadius,
                          ),
                          child: Center(
                            child: SvgPicture.asset(
                              SvgPaths.iconTransparent,
                              height: 36,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Tarkeez',
                        style: TextUtils.title1(context, color: scheme.primary),
                      ),
                    ],
                  ),
                  const ThemeSwitchButton(),
                ],
              ),
              const SizedBox(height: 164),

              // ──────────────────────────────────────────────
              // Drawer items
              // ──────────────────────────────────────────────
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      AppDrawerItem(
                        title: 'Settings',
                        iconPath: SvgPaths.gear,
                        onTap: () => showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) =>
                              const SettingsBottomSheet(),
                        ),
                      ),
                      AppDrawerItem(
                        title: 'User manual',
                        iconPath: SvgPaths.book,
                        onTap: () => context.push(RouteNames.userManualPage),
                      ),
                      AppDrawerItem(
                        title: 'Feedback',
                        iconPath: SvgPaths.penLine,
                        onTap: () => context.push(RouteNames.feedbackPage),
                      ),
                      AppDrawerItem(
                        title: 'Make app',
                        iconPath: SvgPaths.appStore,
                        onTap: () => context.push(RouteNames.hireUsPage),
                      ),
                    ],
                  ),
                ),
              ),
              const SubscriptionCard(),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: .spaceBetween,
                children: [
                  CupertinoButton(
                    onPressed: () =>
                        context.push(RouteNames.termsAndConditionsPage),
                    sizeStyle: .small,
                    alignment: .centerLeft,
                    padding: .zero,
                    child: Text(
                      'Terms and conditions',
                      style: TextUtils.paragraphSmallBold(
                        context,
                        color: scheme.onTertiary.withValues(alpha: .5),
                      ),
                    ),
                  ),
                  Text(
                    'Version: 1.0.0',
                    style: TextUtils.paragraphSmallBold(
                      context,
                      color: scheme.onTertiary.withValues(alpha: .25),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
