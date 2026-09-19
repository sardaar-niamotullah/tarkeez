import 'package:tarkeez/core/shared_files/buttons/disclaimer_text_button.dart';
import 'package:tarkeez/core/shared_files/buttons/primary_button.dart';
import 'package:tarkeez/core/shared_files/widgets/action_page_icon.dart';
import 'package:tarkeez/core/shared_files/widgets/stand_alone_page_outer_structure.dart';
import 'package:flutter/material.dart';
import 'package:tarkeez/core/constants/svg_paths.dart';
import 'package:tarkeez/core/utils/text_utils.dart';
import 'package:tarkeez/features/subscription/presentation/models/pricing_plan.dart';
import 'package:tarkeez/features/subscription/presentation/sections/premium_perks_section.dart';
import 'package:tarkeez/features/subscription/presentation/sections/subscription_bottom_sheet.dart';
import 'package:tarkeez/features/subscription/presentation/sections/widgets/pricing_card.dart';

class SubscriptionPage extends StatefulWidget {
  const SubscriptionPage({super.key});

  @override
  State<SubscriptionPage> createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends State<SubscriptionPage> {
  PricingPlanType _selectedPricingPlanType = PricingPlanType.regularDeal;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final selectedPlan = pricingPlans.firstWhere(
      (plan) => plan.type == _selectedPricingPlanType,
    );

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
            backgroundColorLeft: selectedPlan.color,
            backgroundColorRight: selectedPlan.colorBright,
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
            children: pricingPlans.map((plan) {
              return PricingCard(
                dealValue: plan.dealValue,
                duration: plan.duration,
                price: plan.price,
                saveAmount: plan.saveAmount,
                color: plan.color,
                colorBright: plan.colorBright,
                iconPath: plan.iconPath,
                isActive: plan.type == _selectedPricingPlanType,
                onTap: () =>
                    setState(() => _selectedPricingPlanType = plan.type),
              );
            }).toList(),
          ),

          // ──────────────────────────────────────────────────────────
          // Perks
          // ──────────────────────────────────────────────────────────
          PremiumPerksSection(iconColor: selectedPlan.color),
        ],
      ),
    );
  }
}
