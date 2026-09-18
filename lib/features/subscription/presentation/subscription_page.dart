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

class _PricingPlan {
  const _PricingPlan({
    required this.dealValue,
    required this.duration,
    required this.price,
    required this.saveAmount,
    required this.color,
    required this.colorBright,
    required this.iconPath,
    this.isActive = false,
  });

  final String dealValue;
  final String duration;
  final String price;
  final String saveAmount;
  final Color color;
  final Color colorBright;
  final String iconPath;
  final bool isActive;
}

class SubscriptionPage extends StatelessWidget {
  const SubscriptionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    const pricingPlans = [
      _PricingPlan(
        dealValue: 'Regular deal',
        duration: '3 months',
        price: '1.9',
        saveAmount: 'Save 0%',
        color: AppTheme.blue,
        colorBright: AppTheme.blueBright,
        iconPath: SvgPaths.bookmark,
        isActive: true,
      ),
      _PricingPlan(
        dealValue: 'Good deal',
        duration: '6 months',
        price: '2.9',
        saveAmount: 'Save 23%',
        color: AppTheme.purple,
        colorBright: AppTheme.purpleBright,
        iconPath: SvgPaths.bookmark,
      ),
      _PricingPlan(
        dealValue: 'Better deal',
        duration: '1 year',
        price: '3.9',
        saveAmount: 'Save 48%',
        color: AppTheme.pink,
        colorBright: AppTheme.pinkBright,
        iconPath: SvgPaths.bookmark,
      ),
      _PricingPlan(
        dealValue: 'Best deal',
        duration: 'Life time',
        price: '4.9',
        saveAmount: 'Maximum saving',
        color: AppTheme.fireTone,
        colorBright: AppTheme.lightningGold,
        iconPath: SvgPaths.bookmark,
      ),
    ];

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
          SliverGrid.count(
            crossAxisCount: 2,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 1.4,
            children: pricingPlans
                .map(
                  (plan) => PricingCard(
                    dealValue: plan.dealValue,
                    duration: plan.duration,
                    price: plan.price,
                    saveAmount: plan.saveAmount,
                    color: plan.color,
                    colorBright: plan.colorBright,
                    iconPath: plan.iconPath,
                    isActive: plan.isActive,
                  ),
                )
                .toList(),
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
                  title: 'Unlimited projects',
                  subTitle: 'Break past the 2-project limit and manage everything at once, freely.',
                  iconPath: SvgPaths.projects,
                  iconColor: scheme.primary,
                ),
                PerkTile(
                  title: 'Advanced insights',
                  subTitle: 'Unlock heatmaps, personal bests, invested times and other advanced insights',
                  iconPath: SvgPaths.graphUp,
                  iconColor: scheme.primary,
                ),
                PerkTile(
                  title: 'Extended date filters',
                  subTitle: 'Unlock more ranges in report filter, from last month to all time.',
                  iconPath: SvgPaths.filter,
                  iconColor: scheme.primary,
                ),
                PerkTile(
                  title: 'Theme colors',
                  subTitle: 'Personalize your app with a curated set of premium color themes.',
                  iconPath: SvgPaths.colorPalette,
                  iconColor: scheme.primary,
                ),
                PerkTile(
                  title: 'Fresh start anytime',
                  subTitle: 'Clear all your data and start fresh, your premium status stays intact.',
                  iconPath: SvgPaths.delete,
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
