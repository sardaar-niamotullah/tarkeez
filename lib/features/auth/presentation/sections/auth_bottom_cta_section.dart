import 'package:tarkeez/core/constants/svg_paths.dart';
import 'package:tarkeez/core/routes/route_names.dart';
import 'package:tarkeez/core/shared_files/buttons/custom_icon_button.dart';
import 'package:tarkeez/core/shared_files/buttons/disclaimer_text_button.dart';
import 'package:tarkeez/core/utils/container_design_utils.dart';
import 'package:tarkeez/core/utils/primary_page_margin.dart';
import 'package:tarkeez/core/utils/rich_text_utils.dart';
import 'package:tarkeez/core/utils/text_utils.dart';
import 'package:tarkeez/features/auth/presentation/sections/widgets/oauth_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AuthBottomCTASection extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isSafeAreaDevice = {
      TargetPlatform.iOS,
      TargetPlatform.android,
    }.contains(Theme.of(context).platform);
    return Container(
      height: 350,
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: ContainerDesignUtils.topRadius,
      ),
      child: PrimaryPageMargin(
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 36),
              // ──────────────────────────────────────────────────────────
              // Intro and switch language button
              // ──────────────────────────────────────────────────────────
              Row(
                mainAxisAlignment: .spaceBetween,
                crossAxisAlignment: .start,
                children: [
                  RichText(
                    text: TextSpan(
                      children: RichTextUtils.buildStyledText(
                        text: 'Get started with {Tarkeez}',
                        normalStyle: TextUtils.title2Normal(context),
                        highlightedStyle: TextUtils.title2Normal(
                          context,
                          color: scheme.primary,
                        ),
                      ),
                    ),
                  ),
                  // LanguageSwitchButton(),
                ],
              ),
              const SizedBox(height: 16),

              // ──────────────────────────────────────────────────────────
              // Google oauth button
              // ──────────────────────────────────────────────────────────
              const OauthButton(),
              const SizedBox(height: 8),

              // ──────────────────────────────────────────────────────────
              // Tagline
              // ──────────────────────────────────────────────────────────
              Text(
                'Keep track of the most valuable and limited\nresource you have access to, which is time.',
                style: TextUtils.paragraphSmall(
                  context,
                  color: scheme.onTertiary,
                ),
                textAlign: .center,
              ),
              const Spacer(flex: 2),

              // ──────────────────────────────────────────────────────────
              // Footer content
              // ──────────────────────────────────────────────────────────
              Row(
                mainAxisAlignment: .spaceBetween,
                children: [
                  // ──────────────────────────────────────────────────────────
                  // Customer Care
                  // ──────────────────────────────────────────────────────────
                  CustomIconButton(
                    iconPath: SvgPaths.penLine,
                    onTap: () => context.push(RouteNames.feedbackPage),
                  ),

                  // ──────────────────────────────────────────────────────────
                  // Terms and conditions
                  // ──────────────────────────────────────────────────────────
                  DisclaimerTextButton(),
                  CustomIconButton(
                    iconPath: SvgPaths.hammer,
                    onTap: () =>
                        context.push(RouteNames.termsAndConditionsPage),
                  ),
                ],
              ),
              SizedBox(height: !isSafeAreaDevice ? 16 : 0),
            ],
          ),
        ),
      ),
    );
  }
}
