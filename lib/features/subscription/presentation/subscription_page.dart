import 'package:tarkeez/core/localization/app_texts.dart';
import 'package:tarkeez/core/shared_files/buttons/disclaimer_text_button.dart';
import 'package:tarkeez/core/shared_files/buttons/primary_button.dart';
import 'package:tarkeez/core/shared_files/widgets/action_page_icon.dart';
import 'package:tarkeez/core/shared_files/widgets/stand_alone_page_outer_structure.dart';
import 'package:flutter/material.dart';
import 'package:tarkeez/core/constants/svg_paths.dart';
import 'package:tarkeez/core/theme/theme.dart';
import 'package:tarkeez/core/utils/text_utils.dart';
import 'package:tarkeez/features/subscription/presentation/sections/subscription_bottom_sheet.dart';
import 'package:tarkeez/features/subscription/presentation/sections/widgets/perk_tile.dart';
import 'package:tarkeez/features/subscription/presentation/sections/widgets/pricing_card.dart';

class SubscriptionPage extends StatelessWidget {
  const SubscriptionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final texts = AppTexts.of(context);
    final scheme = Theme.of(context).colorScheme;

    return StandAlonePageOuterStructure(
      title: texts.buyPremium,
      actions: [ActionPageIcon(iconPath: SvgPaths.medal)],

      // ──────────────────────────────────────────────────────────
      // Bottom nav content
      // ──────────────────────────────────────────────────────────
      bottomNavContent: Column(
        mainAxisSize: .min,
        children: [
          PrimaryButton(
            title: texts.next,
            onPressed: () {
              showModalBottomSheet(
                context: context,
                backgroundColor: Colors.transparent,
                builder: (BuildContext context) =>
                    SubscriptionBottomSheet(isStorageCostIncluded: true),
              );
            },
          ),
          const SizedBox(height: 8),
          const DisclaimerTextButton(),
        ],
      ),

      // ──────────────────────────────────────────────────────────
      // Body content
      // ──────────────────────────────────────────────────────────
      content: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const .symmetric(vertical: 16),
              child: Text(
                texts.premiumPackageSelectionIntro,
                style: TextUtils.paragraph(context, color: scheme.onTertiary),
              ),
            ),
          ),

          // ──────────────────────────────────────────────────────────
          // Subscription plan buttons
          // ──────────────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Column(
              children: [
                Row(
                  children: [
                    PricingCard(
                      dealValue: texts.regularDeal,
                      duration: '1 ${texts.month}',
                      price: '2.9',
                      saveAmount: '0%',
                      color: AppTheme.blue,
                      colorBright: AppTheme.blueBright,
                      iconPath: SvgPaths.bookmark,
                      isActive: true,
                      isFreeCard: false,
                    ),
                    const SizedBox(width: 8),
                    PricingCard(
                      dealValue: texts.goodDeal,
                      duration: '3 ${texts.months}',
                      price: '4.9',
                      saveAmount: '43%',
                      color: AppTheme.purple,
                      colorBright: AppTheme.purpleBright,
                      iconPath: SvgPaths.bookmark,
                      isActive: false,
                      isFreeCard: false,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    PricingCard(
                      dealValue: texts.betterDeal,
                      duration: '6 ${texts.months}',
                      price: '6.9',
                      saveAmount: '60%',
                      color: AppTheme.pink,
                      colorBright: AppTheme.pinkBright,
                      iconPath: SvgPaths.bookmark,
                      isActive: false,
                      isFreeCard: false,
                    ),
                    const SizedBox(width: 8),
                    PricingCard(
                      dealValue: texts.bestDeal,
                      duration: '1 ${texts.year}',
                      price: '8.9',
                      saveAmount: '74%',
                      color: AppTheme.fireTone,
                      colorBright: AppTheme.lightningGold,
                      iconPath: SvgPaths.bookmark,
                      isFreeCard: false,
                    ),
                  ],
                ),
              ],
            ),
          ),

          SliverPadding(
            padding: const .symmetric(vertical: 16),
            sliver: SliverList.list(
              children: [
                // ──────────────────────────────────────────────────────────
                // Perks
                // ──────────────────────────────────────────────────────────
                Text(
                  texts.premiumPackagePerksIntro,
                  style: TextUtils.paragraph(context, color: scheme.onTertiary),
                ),
                const SizedBox(height: 16),

                PerkTile(
                  title: 'Add profile and cover image',
                  subTitle: texts.tagadaMessageDetails,
                  iconPath: SvgPaths.picture,
                  iconColor: scheme.primary,
                ),
                PerkTile(
                  title: 'Add short bio',
                  subTitle: texts.tagadaMessageDetails,
                  iconPath: SvgPaths.penLine,
                  iconColor: scheme.primary,
                ),
                PerkTile(
                  title: 'Change app theme color',
                  subTitle: texts.unlimitedCustomersDetails,
                  iconPath: SvgPaths.colorPalette,
                  iconColor: scheme.primary,
                ),
                PerkTile(
                  title: 'Unlock all the advanced insights',
                  subTitle: texts.unlimitedCustomersDetails,
                  iconPath: SvgPaths.graphUp,
                  iconColor: scheme.primary,
                ),
                PerkTile(
                  title: texts.downloadReports,
                  subTitle: texts.downloadReportsDetails,
                  iconPath: SvgPaths.download,
                  iconColor: scheme.primary,
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
