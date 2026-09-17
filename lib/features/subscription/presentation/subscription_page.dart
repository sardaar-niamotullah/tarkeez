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
    final scheme = Theme.of(context).colorScheme;

    return StandAlonePageOuterStructure(
      title: 'Go premium',
      actions: [ActionPageIcon(iconPath: SvgPaths.medal)],

      // ──────────────────────────────────────────────────────────
      // Bottom nav content
      // ──────────────────────────────────────────────────────────
      bottomNavContent: Column(
        mainAxisSize: .min,
        children: [
          PrimaryButton(
            title: 'Next',
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
                'Choose your premium membership duration',
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
                      dealValue: 'Regular deal',
                      duration: '3 months',
                      price: '1.9',
                      saveAmount: '0%',
                      color: AppTheme.blue,
                      colorBright: AppTheme.blueBright,
                      iconPath: SvgPaths.bookmark,
                      isActive: true,
                      isFreeCard: false,
                    ),
                    const SizedBox(width: 8),
                    PricingCard(
                      dealValue: 'Good deal',
                      duration: '6 months',
                      price: '2.9',
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
                      dealValue: 'Better deal',
                      duration: '1 year',
                      price: '3.9',
                      saveAmount: '60%',
                      color: AppTheme.pink,
                      colorBright: AppTheme.pinkBright,
                      iconPath: SvgPaths.bookmark,
                      isActive: false,
                      isFreeCard: false,
                    ),
                    const SizedBox(width: 8),
                    PricingCard(
                      dealValue: 'Best deal',
                      duration: 'Life time',
                      price: '4.9',
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
                  'Your premium membership unlocks these exclusive features',
                  style: TextUtils.paragraph(context, color: scheme.onTertiary),
                ),
                const SizedBox(height: 16),

                PerkTile(
                  title: 'Change app theme color',
                  subTitle: 'Chnage app theme colors of your choice',
                  iconPath: SvgPaths.colorPalette,
                  iconColor: scheme.primary,
                ),
                PerkTile(
                  title: 'Unlock all the advanced insights',
                  subTitle: 'Unlocak all the advanced insiges possible',
                  iconPath: SvgPaths.graphUp,
                  iconColor: scheme.primary,
                ),
                PerkTile(
                  title: 'Download reports',
                  subTitle: 'Reports donwload',
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
