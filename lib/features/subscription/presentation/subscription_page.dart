import 'dart:async';

import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:tailwind_breakpoints/tailwind_breakpoints.dart';
import 'package:tarkeez/core/constants/asset_paths.dart';
import 'package:tarkeez/core/shared_files/buttons/disclaimer_text_button.dart';
import 'package:tarkeez/core/shared_files/buttons/primary_button.dart';
import 'package:tarkeez/core/shared_files/widgets/action_page_icon.dart';
import 'package:tarkeez/core/shared_files/widgets/stand_alone_page_outer_structure.dart';
import 'package:tarkeez/core/utils/sliver_scroll_max_width_box.dart';
import 'package:tarkeez/core/utils/text_utils.dart';
import 'package:tarkeez/features/subscription/presentation/models/pricing_plan.dart';
import 'package:tarkeez/features/subscription/presentation/sections/premium_perks_section.dart';
import 'package:tarkeez/features/subscription/presentation/sections/widgets/pricing_card.dart';

class SubscriptionPage extends StatefulWidget {
  const new({super.key});

  @override
  State<SubscriptionPage> createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends State<SubscriptionPage> {
  final _iap = InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>>? _purchaseSub;

  PricingPlanType _selectedPricingPlanType = PricingPlanType.regularDeal;
  Map<String, ProductDetails>? _products; // null = still loading

  @override
  void initState() {
    super.initState();
    _purchaseSub = _iap.purchaseStream.listen(_onPurchases);
    _loadProducts();
  }

  @override
  void dispose() {
    _purchaseSub?.cancel();
    super.dispose();
  }

  Future<void> _loadProducts() async {
    final response = await _iap.queryProductDetails(
      pricingPlans.map((plan) => plan.productId).toSet(),
    );
    if (!mounted) return;
    setState(() {
      _products = {for (final p in response.productDetails) p.id: p};
    });
  }

  Future<void> _onPurchases(List<PurchaseDetails> purchases) async {
    for (final purchase in purchases) {
      if (purchase.status == PurchaseStatus.error && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Purchase failed. Please try again.')),
        );
      }

      if (purchase.status == PurchaseStatus.purchased ||
          purchase.status == PurchaseStatus.restored) {
        // TODO: send purchase.verificationData.serverVerificationData
        // and purchase.productID to the backend, and wait for it to confirm.
      }

      if (purchase.pendingCompletePurchase) {
        await _iap.completePurchase(purchase);
      }
    }
  }

  String _saveText(PricingPlan plan) {
    final monthly = _products?[pricingPlans.first.productId]?.rawPrice;
    final price = _products?[plan.productId]?.rawPrice;
    if (monthly == null || price == null) return '';
    final percent = ((1 - price / plan.months / monthly) * 100).floor();
    return 'Save $percent%';
  }

  void _buy(PricingPlan plan) {
    final product = _products?[plan.productId];
    if (product == null) return;
    _iap.buyNonConsumable(
      purchaseParam: PurchaseParam(productDetails: product),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final selectedPlan = pricingPlans.firstWhere(
      (plan) => plan.type == _selectedPricingPlanType,
    );

    return StandAlonePageOuterStructure(
      title: 'Go premium',
      actions: [ActionPageIcon(iconPath: AssetPaths.medal)],

      // ──────────────────────────────────────────────────────────
      // Bottom nav content
      // ──────────────────────────────────────────────────────────
      bottomNavContent: Column(
        mainAxisSize: .min,
        children: [
          Text(
            'Renews automatically. Cancel anytime in Google Play.',
            style: TextUtils.paragraph(context, color: scheme.onTertiary),
            textAlign: .center,
          ),
          const SizedBox(height: 8),
          PrimaryButton(
            title: 'Next',
            backgroundColorLeft: selectedPlan.color,
            backgroundColorRight: selectedPlan.colorBright,
            onPressed: () => _buy(selectedPlan),
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
              child: Text(
                'Choose your premium membership duration',
                style: TextUtils.paragraph(context, color: scheme.onTertiary),
              ),
            ),
          ),

          // ──────────────────────────────────────────────────────────
          // Subscription plan buttons
          // ──────────────────────────────────────────────────────────
          if (_products == null)
            const SliverToBoxAdapter(
              child: Center(child: CircularProgressIndicator()),
            )
          else if (_products!.isEmpty)
            SliverToBoxAdapter(
              child: Text(
                'Plans are not available right now. Please try again later.',
                style: TextUtils.paragraph(context, color: scheme.onTertiary),
              ),
            )
          else
            SliverGrid.count(
              crossAxisCount: context.sm ? 4 : 2,
              mainAxisSpacing: context.sm ? 12 : 8,
              crossAxisSpacing: context.sm ? 12 : 8,
              childAspectRatio: context.between(Breakpoints.sm, Breakpoints.md)
                  ? 1
                  : 1.4,
              children: pricingPlans.map((plan) {
                return PricingCard(
                  dealValue: plan.dealValue,
                  duration: plan.duration,
                  price: _products![plan.productId]?.price ?? '',
                  saveAmount: _saveText(plan),
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
