import 'package:tarkeez/core/shared_files/bottom_sheet/bottom_sheet_wrapper.dart';
import 'package:tarkeez/core/shared_files/buttons/bkash_payment_button.dart';
import 'package:flutter/material.dart';
import 'package:tarkeez/core/constants/svg_paths.dart';
import 'package:tarkeez/core/theme/theme.dart';
import 'package:tarkeez/core/utils/text_utils.dart';
import 'package:tarkeez/features/subscription/presentation/sections/widgets/bottom_sheet_widgets/subscription_bottom_sheet_pricing_details_tile.dart';
import 'package:tarkeez/features/subscription/presentation/sections/widgets/bottom_sheet_widgets/subscription_bottom_sheet_total_amount_tile.dart';

class SubscriptionBottomSheet extends StatelessWidget {
  final bool isStorageCostIncluded;
  const SubscriptionBottomSheet({
    super.key,
    required this.isStorageCostIncluded,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return BottomSheetWrapper(
      bottomMargin: 0,
      contents: [
        if (isStorageCostIncluded) ...[
          // ──────────────────────────────────────────────────────────
          // Header
          // ──────────────────────────────────────────────────────────
          Align(
            alignment: .centerRight,
            child: Text(
              'Order summary',
              style: TextUtils.title2(
                context,
                color: scheme.onTertiary.withValues(alpha: .5),
              ),
            ),
          ),
          const SizedBox(height: 18),

          // ──────────────────────────────────────────────────────────
          // Pricing details
          // ──────────────────────────────────────────────────────────
          SubscriptionBottomSheetPricingDetailsTile(
            label: 'Plan price',
            sub: 'Professional · 2 months',
            amount: '99',
            iconPath: SvgPaths.medal,
          ),
          SubscriptionBottomSheetPricingDetailsTile(
            label: 'Storage cost',
            sub: 'Current usage · 2 months',
            amount: '99.24',
            iconPath: SvgPaths.flashDrive,
            onIconTap: () {},
          ),
          const SizedBox(height: 4),
        ],

        if (!isStorageCostIncluded) ...[
          Text(
            'You are just one step away from being a premium user',
            style: TextUtils.paragraph(context, color: scheme.onTertiary),
            textAlign: .center,
          ),
          const SizedBox(height: 24),
        ],
        // ──────────────────────────────────────────────────────────
        // Total amount
        // ──────────────────────────────────────────────────────────
        SubscriptionBottomSheetTotalAmountTile(
          amount: 297,
          iconColor: AppTheme.purple,
        ),
        const SizedBox(height: 8),

        // ──────────────────────────────────────────────────────────
        // CTA
        // ──────────────────────────────────────────────────────────
        BkashPaymentButton(
          title: 'Buy with bKash',
          backgroundColorLeft: AppTheme.purpleBright,
          backgroundColorRight: AppTheme.purple,
        ),
      ],
    );
  }
}
