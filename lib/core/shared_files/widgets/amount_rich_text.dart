import 'package:flutter/material.dart';
import 'package:tarkeez/core/utils/text_utils.dart';

class AmountRichText extends StatelessWidget {
  final num amount;
  const AmountRichText({super.key, required this.amount});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: '৳ ',
            style: TextUtils.title3(
              context,
              color: scheme.onTertiary.withValues(alpha: .5),
            ),
          ),
          TextSpan(
            text: amount.toString(),
            style: TextUtils.title1(context, color: scheme.onTertiary),
          ),
        ],
      ),
    );
  }
}
