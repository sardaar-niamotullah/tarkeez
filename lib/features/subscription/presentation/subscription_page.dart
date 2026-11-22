import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:tailwind_breakpoints/tailwind_breakpoints.dart';
import 'package:tarkeez/core/constants/asset_paths.dart';
import 'package:tarkeez/core/shared_files/buttons/disclaimer_text_button.dart';
import 'package:tarkeez/core/shared_files/buttons/primary_button.dart';
import 'package:tarkeez/core/shared_files/cubits/premium_cubit.dart';
import 'package:tarkeez/core/shared_files/snackbar/snack_bar_public_api.dart';
import 'package:tarkeez/core/shared_files/widgets/action_page_icon.dart';
import 'package:tarkeez/core/shared_files/widgets/stand_alone_page_outer_structure.dart';
import 'package:tarkeez/core/theme/theme.dart';
import 'package:tarkeez/core/utils/sliver_scroll_max_width_box.dart';
import 'package:tarkeez/core/utils/text_utils.dart';
import 'package:tarkeez/features/subscription/cubit/subscription_cubit.dart';
import 'package:tarkeez/features/subscription/cubit/subscription_state.dart';
import 'package:tarkeez/features/subscription/data/models/pricing_plan.dart';
import 'package:tarkeez/features/subscription/presentation/sections/premium_perks_section.dart';
import 'package:tarkeez/features/subscription/presentation/sections/widgets/pricing_card.dart';

class SubscriptionPage extends StatefulWidget {
  const new({super.key});

  @override
  State<SubscriptionPage> createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends State<SubscriptionPage> {
  PricingPlanType _selectedPricingPlanType = PricingPlanType.regularDeal;

  String _saveText(Map<String, ProductDetails>? products, PricingPlan plan) {
    final monthly = products?[pricingPlans.first.productId]?.rawPrice;
    final price = products?[plan.productId]?.rawPrice;
    if (monthly == null || price == null) return '';
    final percent = ((1 - price / plan.months / monthly) * 100).floor();
    return 'Save $percent%';
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final selectedPlan = pricingPlans.firstWhere(
      (plan) => plan.type == _selectedPricingPlanType,
    );
    final isPremiumUser = context.select((PremiumCubit c) => c.isPremium);

    return BlocConsumer<SubscriptionCubit, SubscriptionState>(
      listenWhen: (_, state) => state.result != PurchaseResult.none,
      listener: (context, state) {
        switch (state.result) {
          case PurchaseResult.success:
            showSuccessSnackBar(
              context,
              message: "Congratulations! Welcome to Tarkeez Premium.",
            );
          case PurchaseResult.failed:
            showErrorSnackBar(
              context,
              message: 'Purchase failed. Please try again.',
            );
          case PurchaseResult.unconfirmed:
            showWarningSnackBar(
              context,
              message: 'Could not confirm your purchase. It will be retried when you reopen the app.',
            );
          case PurchaseResult.none:
            break;
        }
      },
      builder: (context, state) {
        return StandAlonePageOuterStructure(
          title: 'Go premium',
          actions: [ActionPageIcon(iconPath: AssetPaths.medal)],

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
                onPressed: () =>
                    context.read<SubscriptionCubit>().buy(selectedPlan),
              ),
              const SizedBox(height: 8),
              const DisclaimerTextButton(),
            ],
          ),

          // ──────────────────────────────────────────────────────────
          // Body content
          // ──────────────────────────────────────────────────────────
          content: SliverScrollMaxWidthBox(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: .only(top: context.md ? 24 : 16, bottom: 8),
                  child: Column(
                    crossAxisAlignment: .start,
                    children: [
                      if (isPremiumUser) ...[
                        RichText(
                          text: TextSpan(
                            style: TextUtils.paragraphBold(
                              context,
                              color: scheme.onTertiary,
                            ),
                            children: [
                              const TextSpan(text: 'You’re already a '),
                              TextSpan(
                                text: 'Premium member',
                                style: TextStyle(color: AppTheme.fireTone),
                              ),
                              const TextSpan(
                                text: '. Any additional Premium purchase will extend your current subscription.',
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                      Text(
                        'Choose your premium membership duration',
                        style: TextUtils.paragraph(
                          context,
                          color: scheme.onTertiary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ──────────────────────────────────────────────────────────
              // Plan cards
              // ──────────────────────────────────────────────────────────
              SliverGrid.count(
                crossAxisCount: context.sm ? 4 : 2,
                mainAxisSpacing: context.sm ? 12 : 8,
                crossAxisSpacing: context.sm ? 12 : 8,
                childAspectRatio:
                    context.between(Breakpoints.sm, Breakpoints.md) ? 1 : 1.4,
                children: pricingPlans.map((plan) {
                  return PricingCard(
                    dealValue: plan.dealValue,
                    duration: plan.duration,
                    price: state.products?[plan.productId]?.price ?? '',
                    saveAmount: _saveText(state.products, plan),
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
      },
    );
  }
}
