import 'package:flutter_svg/flutter_svg.dart';
import 'package:tarkeez/core/shared_files/buttons/theme_switch_button.dart';
import 'package:tarkeez/core/utils/container_design_utils.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tarkeez/core/constants/svg_paths.dart';
import 'package:tarkeez/core/localization/app_texts.dart';
import 'package:tarkeez/core/routes/route_names.dart';
import 'package:tarkeez/core/theme/theme.dart';
import 'package:tarkeez/core/utils/text_utils.dart';
import 'package:tarkeez/features/home/presentation/sections/widgets/app_drawer_item.dart';
import 'package:tarkeez/features/settings/presentation/settings_bottom_sheet.dart';
import 'package:tarkeez/features/subscription/presentation/sections/subscription_card.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final texts = AppTexts.of(context);

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
                        texts.appTitle,
                        style: TextUtils.title1(context, color: scheme.primary),
                      ),
                    ],
                  ),

                  const ThemeSwitchButton(),
                ],
              ),
              // const LanguageSwitchButton(),
              const SizedBox(height: 24),
              const SubscriptionCard(),
              const SizedBox(height: 64),

              // ──────────────────────────────────────────────
              // Drawer items
              // ──────────────────────────────────────────────
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      AppDrawerItem(
                        title: texts.userManual,
                        iconPath: SvgPaths.book,
                        onTap: () => context.push(RouteNames.userManualPage),
                      ),
                      AppDrawerItem(
                        title: texts.settings,
                        iconPath: SvgPaths.gear,
                        onTap: () => showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) {
                            return const SettingsBottomSheet();
                          },
                        ),
                      ),
                      AppDrawerItem(
                        title: texts.termsAndConditions,
                        iconPath: SvgPaths.hammer,
                        onTap: () =>
                            context.push(RouteNames.termsAndConditionsPage),
                      ),
                      AppDrawerItem(
                        title: texts.customerCare,
                        iconPath: SvgPaths.headset,
                        onTap: () => context.push(RouteNames.customerCarePage),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),
              Align(
                alignment: .center,
                child: Text(
                  texts.appVersion,
                  style: TextUtils.paragraph(context, color: AppTheme.grey),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
