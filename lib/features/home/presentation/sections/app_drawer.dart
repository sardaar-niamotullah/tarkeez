import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tarkeez/core/shared_files/buttons/theme_switch_button.dart';
import 'package:tarkeez/core/utils/container_design_utils.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tarkeez/core/constants/svg_paths.dart';
import 'package:tarkeez/core/routes/route_names.dart';
import 'package:tarkeez/core/utils/text_utils.dart';
import 'package:tarkeez/features/auth/bloc/auth_bloc.dart';
import 'package:tarkeez/features/home/presentation/sections/widgets/app_drawer_item.dart';
import 'package:tarkeez/features/home/presentation/sections/widgets/social_links.dart';
import 'package:tarkeez/features/home/presentation/sections/widgets/version_and_terms_tile.dart';
import 'package:tarkeez/features/settings/presentation/settings_bottom_sheet.dart';
import 'package:tarkeez/features/subscription/presentation/sections/subscription_card.dart';

class AppDrawer extends StatelessWidget {
  const new({super.key});

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
                              SvgPaths.logoOriginal,
                              height: 28,
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
              const SizedBox(height: 40),
              const SubscriptionCard(isPremiumMember: true),
              const SizedBox(height: 80),

              // ──────────────────────────────────────────────
              // Drawer items
              // ──────────────────────────────────────────────
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      AppDrawerItem(
                        title: 'Sessions',
                        iconPath: SvgPaths.sessions,
                        onTap: () => context.push(RouteNames.sessions),
                      ),
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
                        title: 'Error report',
                        iconPath: SvgPaths.bugMagnifer,
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
              AppDrawerItem(
                title: 'Log out',
                iconPath: SvgPaths.logOut,
                onTap: () => context.read<AuthBloc>().add(SignOutRequested()),
              ),
              const SizedBox(height: 16),
              const SocialLinks(),
              const SizedBox(height: 8),
              const VersionAndTermsTile(),
            ],
          ),
        ),
      ),
    );
  }
}
