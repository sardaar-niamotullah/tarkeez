import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tarkeez/core/utils/text_utils.dart';

class SubscriptionBottomSheetPricingDetailsTile extends StatelessWidget {
  final String label, sub, amount, iconPath;
  final VoidCallback? onIconTap;

  const SubscriptionBottomSheetPricingDetailsTile({
    super.key,
    required this.label,
    required this.sub,
    required this.amount,
    required this.iconPath,
    this.onIconTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      margin: const .only(bottom: 14),
      child: Row(
        crossAxisAlignment: .center,
        children: [
          Expanded(
            child: Row(
              children: [
                InkWell(
                  onTap: onIconTap,
                  child: SvgPicture.asset(
                    iconPath,
                    height: 20,
                    colorFilter: .mode(scheme.onTertiary, .srcIn),
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: .start,
                  children: [
                    Text(
                      label,
                      style: TextUtils.paragraphBold(
                        context,
                        color: scheme.onTertiary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      sub,
                      style: TextUtils.paragraphSmall(
                        context,
                        color: scheme.onTertiary.withValues(alpha: .5),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: '৳ ',
                  style: TextUtils.paragraphSmallBold(
                    context,
                    color: scheme.onTertiary.withValues(alpha: .5),
                  ).copyWith(fontSize: 8),
                ),
                TextSpan(
                  text: amount.toString(),
                  style: TextUtils.paragraphBold(
                    context,
                    color: scheme.onTertiary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
