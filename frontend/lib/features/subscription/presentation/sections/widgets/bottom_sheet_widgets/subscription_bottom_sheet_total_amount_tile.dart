import 'package:tarkeez/core/shared_files/widgets/amount_rich_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tarkeez/core/constants/svg_paths.dart';
import 'package:tarkeez/core/utils/container_design_utils.dart';
import 'package:tarkeez/core/utils/text_utils.dart';

class SubscriptionBottomSheetTotalAmountTile extends StatelessWidget {
  final double amount;
  final Color iconColor;
  const SubscriptionBottomSheetTotalAmountTile({
    super.key,
    required this.amount,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: scheme.onSurface,
        borderRadius: ContainerDesignUtils.allRadius,
      ),
      child: ListTile(
        dense: true,
        leading: SvgPicture.asset(
          SvgPaths.medal,
          colorFilter: .mode(iconColor, .srcIn),
        ),
        title: Text(
          'Total Payable',
          style: TextUtils.paragraphBold(context, color: scheme.onTertiary),
        ),
        subtitle: Text(
          '2 months',
          style: TextUtils.paragraphSmall(context, color: scheme.onTertiary),
        ),
        trailing: AmountRichText(amount: amount),
      ),
    );
  }
}
