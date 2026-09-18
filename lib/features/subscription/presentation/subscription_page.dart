import 'package:tarkeez/core/shared_files/buttons/disclaimer_text_button.dart';
import 'package:tarkeez/core/shared_files/buttons/primary_button.dart';
import 'package:tarkeez/core/shared_files/widgets/action_page_icon.dart';
import 'package:tarkeez/core/shared_files/widgets/stand_alone_page_outer_structure.dart';
import 'package:flutter/material.dart';
import 'package:tarkeez/core/constants/svg_paths.dart';
import 'package:tarkeez/core/theme/theme.dart';
import 'package:tarkeez/core/utils/text_utils.dart';
import 'package:tarkeez/features/subscription/presentation/sections/premium_perks_section.dart';
import 'package:tarkeez/features/subscription/presentation/sections/subscription_bottom_sheet.dart';
import 'package:tarkeez/features/subscription/presentation/sections/widgets/pricing_card.dart';

class SubscriptionPage extends StatefulWidget {
  const SubscriptionPage({super.key});

  @override
  State<SubscriptionPage> createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends State<SubscriptionPage> {
  int _selectedPricingCardIndex = 0;
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    const pricingPlans = [
      PricingPlan(
        dealValue: 'Regular deal',
        duration: '3 months',
        price: '1.9',
        saveAmount: 'Save 0%',
        color: AppTheme.blue,
        colorBright: AppTheme.blueBright,
        iconPath: SvgPaths.bookmark,
      ),
      PricingPlan(
        dealValue: 'Good deal',
        duration: '6 months',
        price: '2.9',
        saveAmount: 'Save 23%',
        color: AppTheme.purple,
        colorBright: AppTheme.purpleBright,
        iconPath: SvgPaths.bookmark,
      ),
      PricingPlan(
        dealValue: 'Better deal',
        duration: '1 year',
        price: '3.9',
        saveAmount: 'Save 48%',
        color: AppTheme.pink,
        colorBright: AppTheme.pinkBright,
        iconPath: SvgPaths.bookmark,
      ),
      PricingPlan(
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
            children: List.generate(pricingPlans.length, (index) {
              final plan = pricingPlans[index];
              return PricingCard(
                dealValue: plan.dealValue,
                duration: plan.duration,
                price: plan.price,
                saveAmount: plan.saveAmount,
                color: plan.color,
                colorBright: plan.colorBright,
                iconPath: plan.iconPath,
                isActive: index == _selectedPricingCardIndex,
                onTap: () => setState(() => _selectedPricingCardIndex = index),
              );
            }),
          ),

          // ──────────────────────────────────────────────────────────
          // Perks
          // ──────────────────────────────────────────────────────────
          const PremiumPerksSection(),
        ],
      ),
    );
  }
}
